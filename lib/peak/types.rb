require 'dry/types'

module Peak
  module Types
    include Dry.Types()

    class << self
      def smtp_uri(input)
        if input.instance_of?(::String) || input.instance_of?(::URI::Generic)
          value = input.instance_of?(::String) ? ::URI.parse(input) : input

          query = ::Hash[*(value.query || '').split(/&|=/)].symbolize_keys
          auths = Hash['plain', :plain, 'login', :login, 'cram_md5', :cram_md5]
          modes = Hash['none', OpenSSL::SSL::VERIFY_NONE, 'peer', OpenSSL::SSL::VERIFY_PEER]

          ::Hash[{
            address: value.host,
            port: value.port,
            domain: query.fetch(:domain, nil),
            user_name: value.user,
            password: value.password,
            authentication: auths.fetch(query.fetch(:authentication, 'unknown'), nil),
            enable_starttls_auto: query.fetch(:enable_starttls_auto, false),
            openssl_verify_mode: modes.fetch(query.fetch(:openssl_verify_mode, 'unknown'), nil)
          }]
        else
          input
        end
      end
    end
  end
end
