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
end
