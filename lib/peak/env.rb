# frozen_string_literal: true

module Peak
  module Env
    extend ActiveSupport::Autoload

    autoload :Constants
    autoload :Resolver

    class << self
      def instance
        Peak.config.env.instance
      end

      delegate :required, :optional, :with, to: :instance, allow_nil: true
    end
  end
end
