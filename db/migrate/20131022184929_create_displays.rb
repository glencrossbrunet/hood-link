class CreateDisplays < ActiveRecord::Migration
  def change
    create_table :displays do |t|
      t.string :server_id
      t.string :device_id

      t.timestamps
    end
  end
end
