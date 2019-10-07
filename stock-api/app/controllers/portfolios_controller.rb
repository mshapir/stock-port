class PortfoliosController < ApplicationController

  def index
    @portfolios = Portfolio.find_by(user_id: params[:user_id])
    render json: @portfolios, status: 200
  end

  def create
    @portfolio = Portfolio.create(portfolio_params)
    if @portfolio.save
    response = { message: 'Portfolio created successfully'}
    portfolio = PortfolioSerializer.new(@portfolio)
    render json: {portfolio: portfolio}, status: 201
   else
    render json: {errors: @portfolio.errors.full_messages}, status: :bad
   end
  end

  def get_updated_portfolio
    @portfolio = Portfolio.find_by(user_id: params[:user_id])
    current_prices = get_current_prices(@portfolio)
    render json: {portfolio: @portfolio, current_prices: current_prices, status: 201}
  end

  def get_current_prices(portfolio)
    stocks_controller = StocksController.new
    transactions = portfolio.transactions
    ticker_prices = {}
    porfolio_worth = 0
    transactions.each do |transaction|
      ticker_name = transaction.ticker_name
      if !ticker_prices.include?(ticker_name)
        ticker_price = stocks_controller.get_stock_price(ticker_name).price
        total_shares = transaction.number_of_shares
        ticker_prices[ticker_name] = ticker_price
        porfolio_worth += (total_shares * ticker_price)
      end
    end
    update_networth(portfolio, porfolio_worth)
    return ticker_prices
  end

  def update_networth(portfolio, porfolio_worth)
    portfolio.total_networth = portfolio_worth
    portfolio.save
  end

  private

  def portfolio_params
    params.permit(:user_id)
  end

end
