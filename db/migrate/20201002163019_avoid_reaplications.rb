class AvoidReaplications < ActiveRecord::Migration[6.0]
  def change
    add_index :applications, [:applicant_id, :jobpost_id], unique: true
  end
end
