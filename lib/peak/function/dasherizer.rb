module Peak
  module Function
    class Dasherizer < Transformer
      recursion do
        is ::Hash do
          map_keys do
            to_string
          end
          map_keys do
            dasherize
          end
        end
      end
    end
  end
end
