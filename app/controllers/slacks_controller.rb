class SlacksController < ApplicationController
  def show; end

  def exec
    poster = Poster.new uri: params[:uri], text: params[:text]
    poster.exec
    redirect_to slack_path, notice: poster.msg
  end
end
