# frozen_string_literal: true

module Peak
  module Function
    class Simple
      class << self
        def authenticate(token, **options)
          return Peak::JsonWebToken.decode(token, **options)
        rescue JWT::JWKError => exception
          false
        rescue JWT::DecodeError => exception
          false
        rescue Exception => exception
          false
        end
      end
    end
  end
end
