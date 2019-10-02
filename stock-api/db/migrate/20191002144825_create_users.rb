class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.decimal :spending_money, :default => 5000.00, :precision => 16, :scale => 2

      t.timestamps
    end
  end
end
