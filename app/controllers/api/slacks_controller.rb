module Api
  class SlacksController < ApiController
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

    private

    def poster_params
      params.permit(Poster::PERMITTED_PARAMS)
    end

    def poster_json(json)
      json.select { |k, _v| k.in? Poster::PERMITTED_PARAMS.map(&:to_s) }
    end
  end
end
