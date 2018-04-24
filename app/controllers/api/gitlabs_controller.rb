module Api
  class GitlabsController < ApiController
    TRANSFER_OBJECT_KIND = {
      'merge_request' => 'マージリクエスト',
      'issue' => 'Issue'
    }.freeze

    def exec
      load_json
      analyze_json
      return response_json('assignee not changed') unless assignee_changed?
      exec_post
      response_json @poster.msg
    rescue StandardError => e
      response_json "something went wrong : #{e.message}"
    end

    private

    def load_json
      req = request.body.read
      @json = JSON.parse(req)
    end

    def analyze_json
      @poster = Poster.new(content_hash: params[:content_hash])
      @poster.mention1 = @json.dig('assignee', 'username')
      @poster.text = analyze_text(@json)
    end

    def exec_post
      @poster.exec
    end

    def response_json(msg)
      render json: { result: msg }
    end

    def poster_params
      params.permit(Poster::PERMITTED_PARAMS)
    end

    def poster_json(json)
      json.select { |k, _v| k.in? Poster::PERMITTED_PARAMS.map(&:to_s) }
    end

    def assignee_changed?
      return false if @json.dig('assignee', 'username').blank?
      # return true  if @json.dig('changes', 'total_time_spent', 'current') == 0
      return false if @json.dig('changes', 'assignee_id').blank?
      true
    end

    def analyze_text(json)
      [
        TRANSFER_OBJECT_KIND[json.dig('object_kind')],
        '確認お願いします',
        "\n",
        json.dig('object_attributes', 'title'),
        "\n",
        json.dig('object_attributes', 'url')
      ].compact.join(' ')
    end
  end
end
