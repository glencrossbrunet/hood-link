class RmDisplays < ActiveRecord::Migration
  def change
    drop_table :displays
  end
end
