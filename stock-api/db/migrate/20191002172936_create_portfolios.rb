class CreatePortfolios < ActiveRecord::Migration[5.2]
  def change
    create_table :portfolios do |t|
      t.decimal :total_networth, :default => 0.00, :precision => 16, :scale => 2
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
