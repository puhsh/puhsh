ActiveAdmin.register Category do
  form do |f|
    f.inputs '' do
      f.input :name
      f.input :status, as: :select, collection: options_for_select([:inactive, :active], :inactive), include_blank: false
    end
    f.actions
  end
end
