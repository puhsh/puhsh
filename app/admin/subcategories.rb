ActiveAdmin.register Subcategory do
  scope :all, default: true
  scope :active
  scope :inactive

  form do |f|
    f.inputs 'Subcategory' do
      f.input :category, as: :select, include_blank: false
      f.input :name
      f.input :status, as: :select, collection: Subcategory.get_status_values, include_blank: false
    end
    f.actions
  end
end
