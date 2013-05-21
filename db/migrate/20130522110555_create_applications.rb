class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name
      t.string :url
      t.integer :status

      t.timestamps
    end
  end
end
