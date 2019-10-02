class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :spending_money.to_s


end
