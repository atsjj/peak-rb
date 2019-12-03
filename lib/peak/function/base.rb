require 'httparty'

module Peak
  module Function
    class Base < Model
      defines :logger, :meta, :openfaas_deserializable, :openfaas_func, :openfaas_headers,
              :openfaas_serializable, :openfaas_url

      logger Undefined

      meta EMPTY_OPTS

      openfaas_deserializable Deserializable
      openfaas_func Undefined
      openfaas_headers EMPTY_OPTS
      openfaas_serializable Serializable
      openfaas_url Undefined

      class << self
        def normalize_body(operations = EMPTY_ARRAY)
          @classes ||= Hash.new.yield_self { |value| value.default = openfaas_serializable; value; }
          @dasherizer ||= Dasherizer.new
          @renderer ||= JSONAPI::Serializable::Renderer.new

          @renderer.render([operations].flatten(1), class: @classes, meta: @dasherizer.call(meta))
        end


        def normalize_options(options = EMPTY_OPTS)
          body = normalize_body(options.fetch(:body, EMPTY_OPTS)).as_json.to_json

          options.merge(body: body, headers: openfaas_headers, logger: logger)
        end

        # Convenience method that returns any content from a HTTP POST request.
        #
        # @return [Any]
        #
        # @api protected
        def post(options = EMPTY_OPTS, &block)
          _options = normalize_options(options)
          _uri = Addressable::URI.parse(openfaas_url).join("function/#{openfaas_func}")

          HTTParty.post(_uri, _options, &block).yield_self { |response|
            raise "request failed with #{_options.inspect}" unless response.success?

            [response.to_h.fetch('data')].flatten(1)
              .map { |payload| openfaas_deserializable.call(payload) }
          }
        end
      end
    end
  end
end
