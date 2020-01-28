module Peak
  module Authentication
    module MaybeToken
      extend ActiveSupport::Concern

      included do
        before_action :authenticated?
      end

      def authenticated?
        Current.token = authenticate_with_http_token do |token, options|
          ::Peak::Function::Simple.authenticate(token, options)
        end
      end
    end
  end
end
