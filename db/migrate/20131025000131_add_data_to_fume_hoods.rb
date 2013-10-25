class AddDataToFumeHoods < ActiveRecord::Migration
  def change
    add_column :fume_hoods, :data, :hstore
  end
end
