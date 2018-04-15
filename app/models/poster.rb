class Poster
  include ActiveModel::Model

  attr_reader :result, :msg, :uri, :text

  validates :uri, :text, presence: true
  validate :check_uri

  def initialize(uri: nil, text: nil)
    @uri  = uri
    @text = text
  end

  def exec
    return failure 'invalid' unless valid?
    send_text
    success 'success'
  rescue StandardError => e
    failure "failure #{e}"
  end

  private

  def send_text
    uri = URI.parse(@uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    req = Net::HTTP::Post.new(uri.request_uri)
    req['Content-Type'] = 'application/json'
    payload = { text: @text }.to_json
    req.body = payload
    https.request(req)
  end

  def check_uri
    return unless @uri
    return if @uri.start_with? 'https://hooks.slack.com/services/'
    errors.add :uri, 'is invalid'
  end

  def success(msg)
    @result = true
    @msg = msg
  end

  def failure(msg)
    @result = false
    @msg = msg
  end
end
