module Peak
  module Function
    class Symbolizer < Transformer
      recursion do
        is ::Hash do
          map_keys do
            to_string
          end
          map_keys do
            to_symbol
          end
        end
      end
    end
  end
end
