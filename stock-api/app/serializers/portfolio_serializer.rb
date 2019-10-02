class PortfolioSerializer < ActiveModel::Serializer
  attributes :id, :total_networth, :transaction_id, :user_id
  belongs_to :user
  has_many :transactions
end
