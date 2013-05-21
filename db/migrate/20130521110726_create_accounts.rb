class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :status
      t.string :name
      t.string :login
      t.string :password_digest
      t.timestamps
    end
  end
end
