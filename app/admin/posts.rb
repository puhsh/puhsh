ActiveAdmin.register Post do
  menu priority: 2
  scope :for_sale
  scope :sold

  filter :title
  filter :description
  
end
