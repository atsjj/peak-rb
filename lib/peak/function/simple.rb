require 'jwt'

module Peak
  module Function
    class Simple < Base
      class << self
        def authenticate(token, options)
          JWT.decode(token)
        rescue JWT::JWKError => exception
          logger.warn("JWT::JWKError #{exception}")
          logger.error(exception.backtrace.join("\n"))
          false
        rescue JWT::DecodeError => exception
          logger.warn("JWT::DecodeError #{exception}")
          logger.error(exception.backtrace.join("\n"))
          false
        rescue Exception => exception
          logger.warn("Peak::Function::Openid #{exception}")
          logger.error(exception.backtrace.join("\n"))
          false
        end
      end
    end
  end
end