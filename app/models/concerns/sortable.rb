module Sortable
  extend ActiveSupport::Concern

  included do
    scope :recent, order('created_at desc')
    scope :oldest, order('created_at asc')
    scope :latest, order('updated_at desc')
    scope :newest, order('id desc')
  end
end
