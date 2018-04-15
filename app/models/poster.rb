class Poster
  include ActiveModel::Model

  PERMITTED_PARAMS = %i[uri text mention1 mention2 mention3].freeze
  attr_reader :result, :msg
  attr_accessor(*PERMITTED_PARAMS)

  validates :uri, :text, presence: true
  validate :check_uri

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
    payload = { text: text_body }.to_json
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

  def text_body
    [
      *mentions,
      @text
    ].join(' ')
  end

  def mentions
    [@mention1, @mention2, @mention3].map(&method(:add_at)).compact
  end

  def add_at(mention)
    return if mention.blank?
    mention_with_at = mention.start_with?('@') ? mention : "@#{mention}"
    "<#{mention_with_at}>"
  end
end
