##################
# Database Backups
##################

if environment == 'production'
  every 1.minute, roles: [:job]  do
    rake 'db:backup', environment: 'production'
  end
end
