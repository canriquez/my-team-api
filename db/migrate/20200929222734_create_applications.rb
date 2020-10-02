class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.integer :applicant_id
      t.boolean :enabled, default: true
      t.references :jobpost, null: false, foreign_key: true

      t.timestamps
    end
  end
end
