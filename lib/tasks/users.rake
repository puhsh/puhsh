namespace :users do
  desc 'Activates user app invites'
  task :activate_app_invite => :environment do
    number_to_take = (2..10).to_a.sample
    AppInvite.status(:inactive).order('position ASC').limit(number_to_take).each do |invite|
      invite.activate!
    end
  end
end
