require 'dry/transformer'

module Peak
  class Transformer < Dry::Transformer[Peak::Transform::Base]
  end
end
