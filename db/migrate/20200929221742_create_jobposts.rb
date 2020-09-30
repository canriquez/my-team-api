class CreateJobposts < ActiveRecord::Migration[6.0]
  def change
    create_table :jobposts do |t|
      t.string :name, null: false
      t.boolean :enabled, null: false
      t.string :image, null: false
      t.integer :author_id, null: false

      t.timestamps
    end
  end
end
