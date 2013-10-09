class CreateFumeHoods < ActiveRecord::Migration
  def change
    create_table :fume_hoods do |t|
      t.references :organization, null: false
      t.string :external_id, null: false
      t.timestamps
    end
    
    add_index :fume_hoods, :external_id, unique: true
  end
end
