class WebhooksController < ApplicationController
  before_action :set_webhook, only: %i[show edit update destroy]

  def index
    @webhooks = Webhook.where(user: current_user)
  end

  def show; end

  def new
    @webhook = Webhook.new
  end

  def edit; end

  def create
    @webhook = Webhook.new(webhook_params)

    respond_to do |format|
      if @webhook.save
        format.html { redirect_to webhooks_path, notice: '作成しました' }
        format.json { render :show, status: :created, location: @webhook }
      else
        format.html { render :new }
        format.json { render json: @webhook.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @webhook.update(webhook_params)
        format.html { redirect_to webhook_path(content_hash: @webhook.content_hash), notice: '更新しました' }
        format.json { render :show, status: :ok, location: @webhook }
      else
        format.html { render :edit }
        format.json { render json: @webhook.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @webhook.destroy
    respond_to do |format|
      format.html { redirect_to webhooks_url, notice: '削除しました' }
      format.json { head :no_content }
    end
  end

  private

  def set_webhook
    @webhook = Webhook.find_by(content_hash: params[:content_hash])
  end

  def webhook_params
    params.require(:webhook).permit(:uri, :name).merge(user_id: current_user.id)
  end
end
