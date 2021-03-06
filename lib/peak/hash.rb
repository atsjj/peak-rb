# frozen_string_literal: true

require 'dry/core/constants'

module Peak
  include Dry::Core::Constants

  class Hash
    class << self
      def get(root, paths, default_value = Undefined)
        tree_paths = paths.split(/\.?@each\.?/)
        tree_paths.reduce(root) do |tree, path|
          case tree
          when ::Array then
            tree.map do |node|
              if block_given?
                get(node, path, &block)
              else
                get(node, path, default_value)
              end
            end
          when ::Hash
            node_paths = path.split('.')

            node_paths.reduce(tree) do |node, key|
              if node.is_a?(::Array)
                index = node_paths.index(key)
                before_path = node_paths[0..(index-1)].join('.')
                after_path = node_paths[index..-1].join('.')
                try_path = "#{before_path}.@each.#{after_path}"

                raise KeyError, "path `#{before_path}` returned an Array, try using `#{try_path}` instead."
              else
                node.fetch(key.to_s) do
                  node.fetch(key.to_sym) do
                    if block_given?
                      yield(key)
                    else
                      if Undefined.equal?(default_value)
                        raise KeyError, "key `#{key}` not found for #{node.class.to_s}"
                      else
                        default_value
                      end
                    end
                  end
                end
              end
            end
          else
            if block_given?
              yield(path)
            else
              if Undefined.equal?(default_value)
                raise KeyError, "key `#{path}` not found for #{tree.class.to_s}"
              else
                default_value
              end
            end
          end
        end
      end
    end
  end
end
