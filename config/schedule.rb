##################
# Database Backups
##################

if environment == 'production'
  every :day, at: '1:30 am', roles: [:job]  do
    rake 'db:backup', environment: 'production'
  end
end
