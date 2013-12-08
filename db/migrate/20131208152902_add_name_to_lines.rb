class AddNameToLines < ActiveRecord::Migration
  def change
    add_column :lines, :name, :string
  end
end
