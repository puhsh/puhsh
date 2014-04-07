ActiveAdmin.register User do
  menu priority: 1
  filter :uid
  filter :name
  filter :first_name
  filter :last_name
  filter :zipcode

  scope :registered
  scope :not_registered

  config.sort_order = "id_asc"

  index do
    column :id
    column :uid
    column :name
    column :first_name
    column :last_name
    column :slug
    column :zipcode
    column :facebook_email
    column :contact_email
    column :created_at
    column :current_sign_in_at
    column :last_sign_in_at
    column :star_count
    column :posts_count
    column :posts_flagged_count
    actions
  end
end
