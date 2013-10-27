class AddAggregatesToFumeHoods < ActiveRecord::Migration
  def change
    add_column :fume_hoods, :aggregates, :json, default: '{}'
  end
end
