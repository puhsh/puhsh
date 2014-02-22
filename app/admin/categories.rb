ActiveAdmin.register Category do
  menu priority: 8
  scope :all, :default => true
  scope :active
  scope :inactive

  form do |f|
    f.inputs '' do
      f.input :name
      f.input :status, as: :select, collection: options_for_select([:inactive, :active], :inactive), include_blank: false
    end
    f.actions
  end
end
