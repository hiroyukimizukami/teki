module Teki
  module Aws
    class OpsWorks
      class NotFoundError < StandardError; end

      def initialize(key:, secret:, region:)
        @key = key
        @secret = secret
        @region = region
      end

      def layers(stack_name)
        layers = {}
        stack(stack_name).layers.each do |layer|
          instances = client.describe_instances(layer_id: layer.id).instances
          layers[layer.shortname] = instances.map { |i| Teki::Aws::Instance.create(i) }
        end
        layers
      end

      def set_time_based_auto_scaling(weekly_schedule)
        puts "TODO impl"
      end

      private

      def stack(name)
        stacks = client.describe_stacks.stacks.map do |s|
          ::Aws::OpsWorks::Stack.new(s.stack_id, client: client)
        end
        stack = stacks.select { |s| s.name == name }.first
        raise NotFoundError, "stack named: #{stack_name}" unless stack
        stack
      end

      def client
        credentials = ::Aws::Credentials.new(@key, @secret)
        ::Aws::OpsWorks::Client.new(region: @region, credentials: credentials)
      end
    end
  end
end
