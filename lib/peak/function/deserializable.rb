require 'jsonapi/deserializable'

module Peak
  module Function
    class Deserializable < JSONAPI::Deserializable::Resource
      def initialize(payload, root: '/data')
        payload.fetch('attributes', nil).try { |value|
          value.try(:keys).try(:each) { |key|
            self.class.attribute(key.to_sym)
          }
        }

        super(payload, root: root)
      end

      id
      key_format { |key| String(key).underscore }
    end
  end
end
