module Peak
  module Authentication
    module Protect
      extend ActiveSupport::Concern

      included do
        before_action :protect_with_authentication
      end

      def protect_with_authentication
        request_http_token_authentication unless authenticated?
      end

      def authenticated?
        Current.token = authenticate_with_http_token do |token, options|
          ::Peak::Function::Openid.authenticate(token, options)
        end
      end
    end
  end
end
