# require_relative 'stocks_controller'

class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
    render json: @transactions, status: 200
  end

  def create
    @stocks_controller = StocksController.new
    stock_price = @stocks_controller.get_stock_price(params[:ticker_name])
    if stock_price[:status] == 500
      render json: stock_price
    elsif (stock_price[:status] == 200 and UsersController.can_make_transaction(params[:user_id], stock_price[:price].to_f, params[:number_of_shares].to_i))
      UsersController.update_spending_money(params[:user_id], stock_price[:price].to_f * params[:number_of_shares].to_i)
      make_transaction(params[:ticker_name], stock_price[:price].to_f, params[:number_of_shares], params[:transaction_type], params[:user_id], params[:portfolio_id])
    else
      render json: {error: "User does not have enough money to buy #{params[:number_of_shares]} shares of #{params[:ticker_name]} @ #{stock_price[:price]}."}, status: :bad
   end
  end


  def show
    render json: @transaction, status: 200
  end

  private

  def transaction_params
    params.permit(:ticker_name, :ticker_price, :number_of_shares, :transaction_type, :user_id, :portfolio_id)
  end

  def make_transaction(ticker_name, ticker_price, number_of_shares, transaction_type, user_id, portfolio_id)
    @transaction = Transaction.create(ticker_name: ticker_name, ticker_price: ticker_price, number_of_shares: number_of_shares, transaction_type: transaction_type, user_id: user_id, portfolio_id: portfolio_id)
    if @transaction.save
      response = { message: 'Transaction created successfully'}
      transaction = TransactionSerializer.new(@transaction)
      render json: {transaction: transaction}, status: 201
    else
      render json: {errors: @transaction.errors.full_messages}, status: :bad
    end
  end

  def find_transaction
    @transaction = Transaction.find(params[:id])
  end

end
