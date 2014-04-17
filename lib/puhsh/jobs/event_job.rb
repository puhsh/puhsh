module Puhsh
  module Jobs
    class EventJob
      @queue = :events

      def self.perform(method, *args)
        new.send(method, *args)
      end

      def self.record_event(opts)
        Resque.enqueue(self, :record_event, opts)
      end

      def record_event(opts)
        opts = HashWithIndifferentAccess.new(opts)
        if valid_event?(opts) && PUHSH_EVENTS[:tracking_enabled]
          self.create_event!(opts)
        end
      end

      protected

      def create_event!(opts)
        conn = Faraday.new(url: "http://#{PUHSH_EVENTS[:host]}:#{PUHSH_EVENTS[:port]}") do |f|
          f.response :logger
          f.adapter  Faraday.default_adapter
        end

        opts = { userId: opts[:user_id], userIPAddress: opts[:user_ip_address], resourceId: opts[:resource_id].to_i, resourceType: opts[:resource_type], controllerName: opts[:controller_name], controllerAction: opts[:controller_action] }

        conn.post do |req|
          req.url '/events'
          req.headers['Content-Type'] = 'application/json'
          req.body = opts.to_json
        end
      end

      def valid_event?(opts)
        opts.present? && opts[:user_id] && opts[:user_ip_address] && opts[:resource_type] && opts[:controller_name] && opts[:controller_action]
      end
    end
  end
end
