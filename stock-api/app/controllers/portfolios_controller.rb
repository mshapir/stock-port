class PortfoliosController < ApplicationController

  def index
    @portfolios = Portfolio.all
    render json: @portfolios, status: 200
  end

  def create
    @portfolio = Portfolio.create(portfolio_params)
    if @portfolio.save
    response = { message: 'Transaction created successfully'}
    portfolio = PortfolioSerializer.new(@portfolio)
    render json: {portfolio: portfolio}, status: 201
   else
    render json: {errors: @portfolio.errors.full_messages}, status: :bad
   end
  end

  private

  def portfolio_params
    params.permit(:user_id)
  end

end
