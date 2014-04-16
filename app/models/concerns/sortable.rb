module Sortable
  extend ActiveSupport::Concern

  included do
    scope :recent, -> { order("#{table_name}.created_at desc") }
    scope :oldest, -> { order("#{table_name}.created_at asc") }
    scope :latest, -> { order("#{table_name}.updated_at desc") }
    scope :newest, -> { order("#{table_name}.id desc") }
    scope :alpha, -> { order("#{table_name}.name asc") }
    scope :reverse_alpha, -> { order("#{table_name}.name desc") }
  end
end
