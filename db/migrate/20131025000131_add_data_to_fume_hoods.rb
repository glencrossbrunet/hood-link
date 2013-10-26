class AddDataToFumeHoods < ActiveRecord::Migration
  def change
    add_column :fume_hoods, :data, :json, default: '{}'
  end
end
