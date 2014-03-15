ActiveAdmin.register FollowedCity do
  index do
    column :id
    column :user_id
    column :city_id
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs  do
      f.input :city_id, label: 'City ID'
      f.input :user_id, label: 'User ID'
    end
    f.actions
  end
  
end
