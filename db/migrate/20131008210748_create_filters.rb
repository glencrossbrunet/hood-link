class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :key, null: false
      t.references :organization, null: false
      t.timestamps
    end
  end
end
