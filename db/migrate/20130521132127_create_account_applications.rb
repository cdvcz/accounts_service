class CreateAccountApplications < ActiveRecord::Migration
  def change
    create_table :account_applications do |t|
      t.integer :account_id
      t.integer :application_id
      t.integer :user_id
      t.timestamps
    end
  end
end
