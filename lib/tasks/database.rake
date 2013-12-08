namespace :db do
  desc 'Performs a backup of the database' 
  task :backup, [:env] => :environment do |t, args|
    require 'aws/s3'

    args.with_defaults(env: Rails.env)

    config = YAML.load_file(File.join(Rails.root, 'config', 'database.yml'))[args[:env]]
    s3_config = YAML.load(File.read(File.join(Rails.root, 'config', 's3.yml')))[args[:env]]
    
    filename = "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{config['database']}.sql"
    filename_with_path = File.join(Rails.root, 'tmp', filename)
    filename_gzip = "#{filename}.gz"
    filename_gzip_with_path = "#{filename_with_path}.gz"

    bucket = Rails.env.production? ? 'puhsh' : "puhsh_#{Rails.env}"

    command = ['mysqldump']
    command << "-u#{config['username']}"
    command << "-p#{config['password']}" unless config['password'].blank?
    command << "-h#{config['host'] || '127.0.0.1'}"
    command << "--single-transaction"
    command << config['database']
    command << "> #{filename_with_path}"

    if system(command.join(' ')) && system("gzip #{filename_with_path}")
      s3 = AWS::S3.new(access_key_id: s3_config['access_key_id'], secret_access_key: s3_config['secret_access_key'])
      begin
        backup = s3.buckets[bucket].objects.create("database-backups/#{filename_gzip}", filename_gzip)
        backup.write(open(filename_gzip_with_path))
        HipChat::Client.new('cc96625c3ca88a6ac4d79958addc4c')['Fun Town'].send('Capistrano', 'Production DB Backup complete. Uploaded to S3.', color: 'green')
      rescue 
        Rails.logger.debug("Couldn't move db backup to S3")
        HipChat::Client.new('cc96625c3ca88a6ac4d79958addc4c')['Fun Town'].send('Capistrano', 'Production DB Backup failed', color: 'red')
      end

      [filename_gzip_with_path].each { |x| File.delete(x) }
    end
  end
end
