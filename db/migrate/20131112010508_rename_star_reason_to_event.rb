class RenameStarReasonToEvent < ActiveRecord::Migration
  def up
    rename_column :stars, :reason, :event
  end

  def down
    rename_column :stars, :event, :reason
  end
end
