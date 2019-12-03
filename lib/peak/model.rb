require 'dry/core/class_attributes'
require 'dry/core/constants'
require 'dry/equalizer'

module Peak
  class Model
    extend Dry::Core::ClassAttributes
    extend Initializer
    include Dry::Core::Constants
    include Dry::Equalizer(:to_hash)

    def to_hash(*)
      self.class.dry_initializer.attributes(self)
    end

    def to_h(*)
      to_hash
    end
  end
end
