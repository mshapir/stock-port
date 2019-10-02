class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :ticker_name, :ticker_price, :number_of_shares, :transaction_type, :user_id
  belongs_to :user
  belongs_to :portfolio

end
