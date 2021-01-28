# frozen_string_literal: true

module Peak
  module Authentication
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Current
    autoload :MaybeToken
  end
end
