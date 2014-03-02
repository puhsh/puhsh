namespace :devices do
  desc 'Updates blank devices'
  task :update_blank_types => :environment do
    if Device.count > 0
      Device.find_in_batches(batch_size: 100).each do |devices|
        devices.each do |device|
          next unless device.device_type.blank?
          device.device_type = :ios
          device.save
        end
      end
    end
  end

  desc 'Remove invalid tokens with spaces'
  task :remove_invalid_tokens => :environment do
    User.includes(:devices).find_each do |user|
      if user.devices.ios.count > 1
        user.devices.ios.last.destroy
      end
    end
  end
end
