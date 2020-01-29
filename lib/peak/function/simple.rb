require 'jwt'

module Peak
  module Function
    class Simple < Base
      class << self
        def authenticate(token, options)
          secret = options.fetch(:secret, nil)
          algorithm = options.fetch(:algorithm, 'HS256')

          return JWT.decode(token, secret, true, { algorithm: algorithm })
        rescue JWT::JWKError => exception
          logger.warn("JWT::JWKError #{exception}")
          logger.error(exception.backtrace.join("\n"))
          false
        rescue JWT::DecodeError => exception
          logger.warn("JWT::DecodeError #{exception}")
          logger.error(exception.backtrace.join("\n"))
          false
        rescue Exception => exception
          logger.warn("Peak::Function::Simple #{exception}")
          logger.error(exception.backtrace.join("\n"))
          false
        end
      end
    end
  end
end
