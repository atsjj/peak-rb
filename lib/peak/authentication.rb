module Peak
  module Authentication
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Current
    autoload :Protect
  end
end
