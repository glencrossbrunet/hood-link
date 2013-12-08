class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.json :filters
      t.boolean :visible
      t.references :user, index: true
      t.references :organization, index: true

      t.timestamps
    end
  end
end
