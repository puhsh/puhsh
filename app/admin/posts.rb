ActiveAdmin.register Post do
  menu priority: 2
  scope :for_sale
  scope :sold

  filter :title
  filter :description

  index do
    column :id
    column :title
    column :slug
    column :description
    column :pick_up_location
    column :payment_type
    column :status
    column :created_at
    column :updated_at
    actions do |post|
      link_to 'View Page', post_path(post.city_id, post.user.slug, post.slug), target: :blank
    end
  end
end
