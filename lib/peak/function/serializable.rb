require 'jsonapi/serializable'

module Peak
  module Function
    class Serializable < JSONAPI::Serializable::Resource
      extend JSONAPI::Serializable::Resource::KeyFormat

      def initialize(exposures = EMPTY_OPTS)
        exposures.fetch(:object, nil).try { |value|
          value.try(:to_hash).try(:keys).try(:each) { |key|
            self.class.attribute(key) { @object.fetch(key) }
          }
        }

        super(exposures)
      end

      id { SecureRandom.uuid }
      key_format { |key| String(key).dasherize }
      type 'functions'
    end
  end
end
