module Api
  class SlacksController < ApplicationController
    protect_from_forgery with: :null_session

    def exec
      poster = Poster.new uri: params[:uri], text: params[:text]
      poster.exec
      render json: { result: poster.msg }
    end

    def exec_json
      req = request.body.read
      json = JSON.parse req
      poster = Poster.new uri: json['uri'], text: json['text']
      poster.exec
      render json: { result: poster.msg }
    end
  end
end
