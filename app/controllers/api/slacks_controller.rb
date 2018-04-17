module Api
  class SlacksController < ApiController
    MODIFY_SYNTAX = {
      '=>' => ':',
      'nil' => 'null'
    }.freeze

    TRANSFER_OBJECT_KIND = {
      'merge_request' => 'マージリクエスト',
      'issue' => 'Issue'
    }

    def exec
      poster = Poster.new poster_params
      poster.exec
      render json: { result: poster.msg }
    end

    def exec_json
      req = request.body.read
      json = JSON.parse(req)
      poster = Poster.new poster_json(json)
      poster.exec
      render json: { result: poster.msg }
    end

    def analyze_and_exec
      req = request.body.read
      json = modify_json(req)
      @poster = Poster.new(content_hash: params[:content_hash])
      analyze_and_set(json)
      @poster.exec
      render json: { result: @poster.msg }
    rescue StandardError => e
      render json: { result: "something went wrong : #{e.message}" }
    end

    private

    def poster_params
      params.permit(Poster::PERMITTED_PARAMS)
    end

    def modify_json(old_json)
      new_json = old_json.dup
      MODIFY_SYNTAX.each do |old, new|
        new_json.gsub!(old, new)
      end
      JSON.parse(new_json)
    end

    def poster_json(json)
      json.select { |k, _v| k.in? Poster::PERMITTED_PARAMS.map(&:to_s) }
    end

    def analyze_and_set(json)
      @poster.mention1 = json.dig('assignee', 'username')
      @poster.text = [
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
