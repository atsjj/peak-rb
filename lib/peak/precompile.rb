module Peak
  module Precompile
    class << self
      def ignore
        unless ARGV.any? { |e| e == 'assets:precompile' }
          yield
        else
          line = caller.first
          puts "Ignoring line '#{line}' during precompile"
        end
      end
    end
  end
end
