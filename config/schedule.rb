########################
# Alpha Queue Processing
########################

# every 10.minutes do
#   rake 'users:activate_app_invite'
# end

##################
# Database Backups
##################

if environment == 'production'
  every :day, at: '1:30 am', roles: [:app]  do
    rake 'db:backup', environment: 'production'
  end
end
