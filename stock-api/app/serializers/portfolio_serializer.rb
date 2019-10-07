class PortfolioSerializer < ActiveModel::Serializer
  attributes :id, :total_networth, :user_id
  belongs_to :user
  has_many :transactions
end
