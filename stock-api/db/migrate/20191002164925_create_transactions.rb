class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :ticker_name
      t.decimal :ticker_price
      t.integer :number_of_shares
      t.string :transaction_type
      t.references :user, foreign_key: true
      t.references :transaction, foreign_key: true

      t.timestamps
    end
  end
end
