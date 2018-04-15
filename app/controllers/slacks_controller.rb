class SlacksController < ApplicationController
  def show
    @poster = Poster.new
  end

  def exec
    poster = Poster.new(poster_params)
    poster.exec
    redirect_to slack_path, notice: poster.msg
  end

  private

  def poster_params
    params.require(:poster).permit(Poster::PERMITTED_PARAMS)
  end
end
