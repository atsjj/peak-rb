# frozen_string_literal: true

require 'dry/configurable'
require 'dry/core/constants'
require 'forwardable'

module Peak
  module Env
    class Resolver
      extend Forwardable
      include Dry::Core::Constants
      include Peak::Env::Constants

      def_delegators :environment, :fetch, :has_key?

      # @!setting [r] environment A hash that contains variables.
      #
      # @return [Hash] environment hash that defaults to ENV.
      #
      # @api public
      def environment
        Peak.config.authentication.env.environment
      end

      # @!setting [r] prefix A prefix that can help resolve environment
      #               variables and when set will further augment the
      #               `namespace` setting.
      #
      # @return [String] prefix used in looking up environment
      #                  variables. Setting the `prefix` to "some"
      #                  with a `namespace` of "project" and trying to
      #                  resolve "url" will attempt to find
      #                  "SOME_PROJECT_URL", "PROJECT_URL" and "URL"
      #                  in the given `environment` hash.
      #
      # @api public
      def prefix
        Peak.config.authentication.env.prefix
      end

      # @!setting [r] namespace A namespace that can help resolve
      #               environment variables.
      #
      # @return [String] namespace used in looking up environment
      #                  variables. Setting the `namespace` to "project"
      #                  and trying to resolve "url" will attempt to
      #                  find "PROJECT_URL" and "URL" in the given
      #                  `environment` hash.
      #
      # @api public
      def namespace
        Peak.config.authentication.env.namespace
      end

      # @!setting [r] target A string for a given application's target
      #               runtime, typically "development", "production" or
      #               "test" that can help differentiate similar
      #               environment variables based on target.
      #
      # @return [String] target used in looking up environment
      #                  variables. Setting the `target` to "test" with
      #                  a `prefix` of "some" with and a `namespace` of
      #                  "project" and trying to resolve "url" will
      #                  attempt to find "SOME_PROJECT_TEST_URL",
      #                  "SOME_PROJECT_URL", "PROJECT_URL" and "URL" in
      #                  the given `environment` hash.
      #
      # @api public
      def target
        Peak.config.authentication.env.target
      end

      # Returns prefixes split on the namespace pattern.
      #
      # @return [Array<String>]
      #
      # @api protected
      def prefixes
        prefix.split(NAMESPACE_PATTERN)
      end

      # Returns namespaces split on the namespace pattern.
      #
      # @return [Array<String>]
      #
      # @api protected
      def namespaces
        namespace.split(NAMESPACE_PATTERN)
      end

      # Returns targets split on the namespace pattern.
      #
      # @return [Array<String>]
      #
      # @api protected
      def targets
        target.split(NAMESPACE_PATTERN)
      end

      # Returns targets split on the namespace pattern.
      #
      # @param [String] key Base name for an environment variable
      #
      # @return [Array<String>]
      #
      # @api protected
      def keys_for(key = EMPTY_STRING)
        key.split(NAMESPACE_PATTERN)
      end

      # Returns a key to be used in looking up an environment variable
      # that contains the prefix, namespace, target and provided keys.
      #
      # @param [Array<String>] keys Keys that will be appended to the
      #                        the end of the search path.
      #
      # @return [String]
      #
      # @api protected
      def with_prefixes_namespaces_targets_key_for(keys = EMPTY_ARRAY)
        [*prefixes, *namespaces, *targets, *keys].join('_').upcase
      end

      # Returns a key to be used in looking up an environment variable
      # that contains namespace, target and provided keys.
      #
      # @param [Array<String>] keys Keys that will be appended to the
      #                        the end of the search path.
      #
      # @return [String]
      #
      # @api protected
      def with_namespaces_targets_key_for(keys = EMPTY_ARRAY)
        [*namespaces, *targets, *keys].join('_').upcase
      end

      # Returns a key to be used in looking up an environment variable
      # that contains prefix, namespace and provided keys.
      #
      # @param [Array<String>] keys Keys that will be appended to the
      #                        the end of the search path.
      #
      # @return [String]
      #
      # @api protected
      def with_prefixes_namespaces_key_for(keys = EMPTY_ARRAY)
        [*prefixes, *namespaces, *keys].join('_').upcase
      end

      # Returns a key to be used in looking up an environment variable
      # that contains namespace and provided keys.
      #
      # @param [Array<String>] keys Keys that will be appended to the
      #                        the end of the search path.
      #
      # @return [String]
      #
      # @api protected
      def with_namespaces_key_for(keys = EMPTY_ARRAY)
        [*namespaces, *keys].join('_').upcase
      end

      # Returns a key to be used in looking up an environment variable
      # that contains prefix and provided keys.
      #
      # @param [Array<String>] keys Keys that will be appended to the
      #                        the end of the search path.
      #
      # @return [String]
      #
      # @api protected
      def with_prefixes_key_for(keys = EMPTY_ARRAY)
        [*prefixes, *keys].join('_').upcase
      end

      # Returns a key to be used in looking up an environment variable
      # that contains the provided keys.
      #
      # @param [Array<String>] keys Keys that will be appended to the
      #                        the end of the search path.
      #
      # @return [String]
      #
      # @api protected
      def with_key_for(keys = EMPTY_ARRAY)
        [*keys].join('_').upcase
      end

      # Returns a set of keys to be used in looking up an environment
      # variable from the provided keys.
      #
      # @param [Array<String>] keys A set of keys that to be combined
      #                        with combinations of prefix, namespace,
      #                        and target.
      #
      # @return [Array<String>]
      #
      # @api protected
      def fetch_keys_for(keys = EMPTY_ARRAY)
        return [
          with_prefixes_namespaces_targets_key_for(keys),
          with_namespaces_targets_key_for(keys),
          with_prefixes_namespaces_key_for(keys),
          with_namespaces_key_for(keys),
          with_prefixes_key_for(keys),
          with_key_for(keys)
        ]
      end

      # Creates a new instance of the resolver with a different target
      # and yields it to a block. The return value of the block is then
      # passed back as a string.
      #
      # @param [String] name The target environment
      #
      # @return [String]
      #
      # @api public
      def with(target = DEFAULT_TARGET)
        klass = Class.new(self.class)
        klass.configure { |c| c.target = target }

        yield(klass.new)
      end

      # Requires that a given environment variable can be fetched and
      # returned with the provided key or raises an error.
      #
      # @param [String] key Base name for an environment variable
      #
      # @raise KeyError when key is not found
      #
      # @return [String]
      #
      # @api public
      def required(key)
        keys = fetch_keys_for(keys_for(key))

        if k = keys.find { |k| has_key?(k) }
          return fetch(k)
        else
          raise(KeyError, "#{keys.join(' or ')} must be provided.")
        end
      end

      # Optionally fetch a given environment variable and return it's
      # value with the provided key or return the value of the default
      # value parameter or return value from block or raises an error
      # if neither default value method is provided.
      #
      # @example with a default_value returning 'a' when key not found.
      #   optional('key', 'a')
      #
      # @example with a block returning 'a' when key not found.
      #   optional('key') { 'a' }
      #
      # @example will raise KeyError when key not found.
      #   optional('key')
      #
      # @param [String] key Base name for an environment variable
      # @param [Object] default_value A default value that can be
      #                 returned if a key is not found.
      #
      # @yieldparam [String] key Base name for an environment variable
      #                      that was not found.
      #
      # @yieldreturn [Object] Anything returned from the provided block
      #                       that acts as the default value when the
      #                       key is not found.
      #
      # @raise KeyError when key is not found and a block and default
      #        value is also not provided.
      #
      # @return [String]
      #
      # @api public
      def optional(key, default_value = Undefined)
        required(key)
      rescue => raise_key_error
        if block_given?
          yield(key)
        else
          if Undefined.equal?(default_value)
            raise(raise_key_error)
          else
            default_value
          end
        end
      end
    end
  end
end
