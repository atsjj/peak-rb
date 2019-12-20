require 'digest'
require 'jwt'

module Peak
  module Function
    class Openid < Base
      defines :symbolizer

      symbolizer Symbolizer.new

      class << self
        def openid_app_whitelist
          config.authentication.openid.audience.whitelist
        end

        def cache
          config.cache_store
        end

        def algorithms
          config.authentication.jwt.algorithms
        end

        def get(uri, options = EMPTY_OPTS, &block)
          HTTParty.get(uri, options, &block).yield_self do |response|
            symbolizer.call(response.to_h)
          end
        end

        def uri(value)
          value
            .to_s
            .yield_self { |value| (value.end_with?('/')) ? value : value << '/' }
            .yield_self { |value| Addressable::URI.parse(value) }
        end

        def openid_audience(payload)
          payload.fetch(:aud)
        end

        def openid_audience_whitelisted?(audience)
          openid_app_whitelist.any? { |aud| aud == audience }
        end

        def openid_whitelisted?(payload)
          openid_audience_whitelisted?(openid_audience(payload))
        end

        def openid_configuration(payload_issuer)
          cache.fetch("openid/configuration/#{Digest::SHA256.hexdigest(payload_issuer)}", expires_in: 1.hour) do
            get(uri(payload_issuer).join('.well-known/openid-configuration'))
          end
        end

        def openid_jwks_uri(openid_configuration)
          openid_configuration.fetch(:jwks_uri)
        end

        def openid_jwks(openid_jwks_uri)
          cache.fetch("openid/jwks/#{Digest::SHA256.hexdigest(openid_jwks_uri)}", expires_in: 1.hour) do
            get(uri(openid_jwks_uri))
          end
        end

        def openid_jwk(header, payload)
          JWT::JWK::KeyFinder
            .new(jwks: openid_jwks(openid_jwks_uri(openid_configuration(payload.fetch(:iss)))))
            .key_for(header.fetch(:kid))
        end

        def authenticate(token, options)
          JWT.decode(token, nil, true, { algorithms: algorithms }) do |header, payload|
            _header = symbolizer.call(header)
            _payload = symbolizer.call(payload)

            if openid_whitelisted?(_payload)
              openid_jwk(_header, _payload)
            else
              false
            end
          end
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