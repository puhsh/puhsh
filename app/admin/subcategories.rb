ActiveAdmin.register Subcategory do
  scope :all, default: true

  form do |f|
    f.inputs '' do
      f.input :category, as: :select, include_blank: false
      f.input :name
      f.input :status, as: :select, collection: options_for_select([:inactive, :active], :inactive), include_blank: false
    end
    f.actions
  end
end
