class UsersController < ApplicationController

  skip_before_action :authenticate_request!, only: [:login, :create]

  def login
    user = User.find_by(email: params[:email].to_s.downcase)

    if user && user.authenticate(params[:password])
        token = JsonWebToken.encode({user_id: user.id})
        user_data = UserSerializer.new(user)
        render json: {token: token, user: user_data}, status: :ok
    else
      render json: {error: 'Invalid username / password'}, status: :unauthorized
    end
  end

  def index
    @users = User.all
    render json: @users, status: 200
  end

  def create
    @user = User.create(user_params)
    if @user.save
    response = { message: 'User created successfully'}
    user = UserSerializer.new(@user)
    token = JsonWebToken.encode({user_id: @user.id})
    render json: {user: user, token: token}, status: 201
   else
    render json: {errors: @user.errors.full_messages}, status: :bad
   end
  end

  def update
  @user.update(user_params)
    if @user.save
      render json: @user, status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessible_entity
    end
  end

  def show
    user = JsonWebToken.decode(request.authorization)
    @user = User.find(user[0]["user_id"])
    render json: @user
  end

  def self.can_make_transaction(user_id, price, number_of_shares)
    spending_money = User.find(user_id).spending_money
    return spending_money >= (price * number_of_shares)
  end

  def self.update_spending_money(user_id, total_spent)
    @user = User.find(user_id)
    if @user.spending_money < total_spent
      return false
    end
    new_spending_money = @user.spending_money - total_spent
    return @user.update_attribute :spending_money, new_spending_money
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

end
