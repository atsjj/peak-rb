module Peak
  module Records
    class << self
      def into_json(&block)
        return unless block_given?

        yield.yield_self do |relation|
          return relation unless relation.respond_to?(:reflect_on_all_associations)

          a = relation.reflect_on_all_associations.map(&:name)
          relation.left_outer_joins(*a).includes(*a).map do |record|
            record.serializable_hash.merge(*a.map { |k| Hash({ k => record.send(k) }) })
          end
        end
      end
    end
  end
end
