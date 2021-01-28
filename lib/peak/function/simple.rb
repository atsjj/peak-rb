# frozen_string_literal: true

module Peak
  module Function
    class Simple
      class << self
        def authenticate(token, **options)
          return Peak::JsonWebToken.decode(token, **options)
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
