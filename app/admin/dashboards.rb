ActiveAdmin.register_page 'Dashboard' do
  content title: 'Overview' do
    div do
      span do
        "Recent Users (25)"
      end
      table_for User.order('created_at desc').limit(25) do
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
  end
end
