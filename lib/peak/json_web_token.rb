require 'dry/core/constants'
require 'jwt'

module Peak
  class JsonWebToken
    include Dry::Core::Constants

    class << self
      # Encodes a JSON Web Token
      #
      # @author Steve Jabour <steve@jabour.me>
      # @param payload [Hash] the hash payload to that will be signed
      # @param expires_at [Integer] the time at which the token expires
      # @param issued_at [Integer] the time at which the token was created
      # @param not_before [Integer] the time when the token may be validated
      # @param algorithm [String] the hashing algorithm to use with `ruby-jwt`
      # @param secret [String] the secret key used in generating the hash
      # @return [String] JSON Web Token
      def encode(payload: EMPTY_HASH, expires_at: expires_at_time, issued_at: issued_at_time, not_before: not_before_time, algorithm: 'HS256', secret: secret_key)
        options = payload.merge({ exp: expires_at, iat: issued_at, nbf: not_before }).delete_if { |k, v| v.nil? }

        JWT.encode(options, secret, algorithm)
      end

      # Encodes a JSON Web Token
      #
      # @author Steve Jabour <steve@jabour.me>
      # @param token [String] the JSON Web Token
      # @param algorithm [String] the hashing algorithm to use with `ruby-jwt`
      # @param secret [String] the secret key used in generating the hash
      # @return [Hash] the JSON Web Token payload
      def decode(token = EMPTY_STRING, algorithm: 'HS256', secret: secret_key)
        JWT.decode(token, secret, true, { algorithm: algorithm })
      end

      protected

      def secret_key
        ::Peak.config.authentication.jwt.secret_key
      end

      def issued_at_time
        Time.now.to_i
      end

      def expires_at_time
        issued_at_time + 86400
      end

      def not_before_time
        issued_at_time - 300
      end
    end
  end
end
