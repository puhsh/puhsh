ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  controller = event.payload[:controller]
  action = event.payload[:action]
  format = event.payload[:format] || "all"
  format = "all" if format == "*/*"
  status = event.payload[:status]
  key = "#{controller}.#{action}.#{format}"

  ActiveSupport::Notifications.instrument :performance, 
                                          :action => :timing, 
                                          :measurement => "#{key}.total_duration", 
                                          :value => event.duration
  ActiveSupport::Notifications.instrument :performance, 
                                          :action => :timing, 
                                          :measurement => "#{key}.db_time", 
                                          :value => event.payload[:db_runtime]
  ActiveSupport::Notifications.instrument :performance, 
                                          :action => :timing, 
                                          :measurement => "#{key}.view_time", 
                                          :value => event.payload[:view_runtime]
  ActiveSupport::Notifications.instrument :performance, 
                                          :measurement => "#{key}.status.#{status}"
  
  ActiveSupport::Notifications.instrument :event
end

ActiveSupport::Notifications.subscribe /performance/ do |name, start, finish, id, payload|
  Puhsh::StatsdReporting.send_event_to_statsd(name, payload) if Rails.env.production?
end


ActiveSupport::Notifications.subscribe /event/ do |payload|
  if Rails.env.production?
    opts = { 
      user_id: payload[:user_id], user_ip_address: payload[:user_ip_address], 
      resource_id: payload[:params][:id], resource_type: params[:resource_type], 
      controller_name: payload[:controller], controller_action: payload[:action]
    }

    Puhsh::Jobs::EventJob.record_event(opts)
  end
end
