require 'transproc/registry'

module Peak
  module Transform
    module Coercions
      extend Transproc::Registry

      class << self
        def to_lowercase(value)
          value.downcase
        end
      end
    end
  end
end
