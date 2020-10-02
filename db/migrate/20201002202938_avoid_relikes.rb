class AvoidRelikes < ActiveRecord::Migration[6.0]
  def change
    def change
      add_index :likess, [:applicantion_id, :admin_id], unique: true
    end
  end
end
