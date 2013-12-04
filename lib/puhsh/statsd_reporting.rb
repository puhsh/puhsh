module Puhsh
  module StatsdReporting

    def self.send_event_to_statsd(name, payload)
      action = payload[:action] || :increment
      measurement = payload[:measurement]
      value = payload[:value]
      key_name = "#{name.to_s.capitalize}.#{measurement}"
      batch = Statsd::Batch.new($statsd)
      batch.__send__ action.to_s, "production.#{key_name}", (value || 1)
      batch.flush
    end

  end
end
