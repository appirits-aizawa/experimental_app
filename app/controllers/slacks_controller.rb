class SlacksController < ApplicationController
  before_action :check_uri, only: :exec

  def show
    @poster = Poster.new
    @webhook_selection = current_user.webhooks.pluck(:name, :content_hash)
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

  def check_uri
    webhook = Webhook.find_by user: current_user, content_hash: params.dig(:poster, :content_hash)
    redirect_to slack_path, alert: '該当Webhookなし' unless webhook
  end
end
