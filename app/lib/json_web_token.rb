class JsonWebToken
  SECRECT_KEY = Rails.application.secrets.secret_key_base.to_s

  def self.encode(payload, algorithm, expire = 24.hours.from_now)
    payload[:expire] = expire.to_i
    JWT.encode(payload, SECRECT_KEY)
  end

  def self.decode(token)
    decode = JWT.decode(token, SECRECT_KEY)[0]
    HashWithIndifferentAccess.new decode
  end
end