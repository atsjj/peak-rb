require 'jwt'

module Peak
  module Function
    class Simple < Base
      class << self
        def algorithms
          config.authentication.jwt.algorithms
        end

        def secret_key
          config.authentication.jwt.secret_key
        end

        def authenticate(token, options)
          return JWT.decode(token, secret_key, true, { algorithm: algorithms })
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
