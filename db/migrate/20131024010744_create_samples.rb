class CreateSamples < ActiveRecord::Migration
  def change
    create_table :sample_metrics do |t|
      t.string :name, null: false
    end
    
    create_table :samples do |t|
      t.references :fume_hood, index: true, null: false
      t.references :sample_metric, index: true, null: false
      t.string :unit
      t.float :value, null: false
      t.string :source
      t.datetime :sampled_at, null: false

      t.timestamps
    end
  end
end