class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.integer :admin_id
      t.integer :evaluation, null: false
      t.references :application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
