class CreateBalcklistedTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :balcklisted_tokens do |t|
      t.string :jti
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :exp

      t.timestamps
    end
    add_index :balcklisted_tokens, :jti, unique: true
  end
end
