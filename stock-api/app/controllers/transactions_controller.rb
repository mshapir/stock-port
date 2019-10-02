class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
    render json: @transactions, status: 200
  end

  def create
    @transaction = Transaction.create(transaction_params)
    if @transaction.save
    response = { message: 'Transaction created successfully'}
    transaction = TransactionSerializer.new(@transaction)
    render json: {transaction: transaction}, status: 201
   else
    render json: {errors: @transaction.errors.full_messages}, status: :bad
   end
  end

  def show
    render json: @transaction, status: 200
  end

  private

  def transaction_params
    params.permit(:ticker_name, :ticker_price, :number_of_shares, :transaction_type, :user_id)
  end
  def find_transaction
    @transaction = Transaction.find(params[:id])
  end

end
