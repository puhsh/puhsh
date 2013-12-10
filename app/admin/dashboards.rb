ActiveAdmin::Dashboards.build do  
  section "Recent Users (15)" do
    table_for User.order('created_at desc').limit(15) do
      column :id do |user|
        link_to user.id, admin_user_path(user)
      end
      column :uid
      column :name
      column :first_name
      column :last_name
      column :zipcode
      column :facebook_email
      column :contact_email
      column :created_at
      column :current_sign_in_at
      column :last_sign_in_at
      column :star_count
    end
  end

  section "Recent Invites (15)" do
    table_for Invite.order('created_at desc').limit(15) do
      column :user_id do |user|
        link_to user.id, admin_user_path(user)
      end
      column :uid_invited
      column :created_at
    end
  end

  section "Recent Stars (15)" do
    table_for Star.order('created_at desc').limit(15) do
      column :user_id do |user|
        link_to user.id, admin_user_path(user)
      end
      column :amount
      column :event
    end
  end
end
