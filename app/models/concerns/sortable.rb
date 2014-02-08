module Sortable
  extend ActiveSupport::Concern

  included do
    scope :recent, order('created_at desc')
    scope :oldest, order('created_at asc')
  end
end
