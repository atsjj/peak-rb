# frozen_string_literal: true

module Peak
  module Authentication
    class Current < ActiveSupport::CurrentAttributes
      attribute :token
    end
  end
end
