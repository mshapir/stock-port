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

  def show
    @portfolio = Portfolio.find_by(user_id: params[:user_id])
    entries = get_updated_portfolio(@portfolio)
    render json: {portfolioObject: @portfolio, total_networth: @portfolio.total_networth, entries: entries, status: 201}
  end

  def get_updated_portfolio(portfolio)
    stocks_controller = StocksController.new
    transactions = portfolio.transactions
    portfolio_entries = {}
    transactions.each do |transaction|
      ticker_name = transaction[:ticker_name]
      total_shares = transaction[:number_of_shares].to_i
      if !portfolio_entries.include?(ticker_name)
        ticker_price = stocks_controller.get_stock_price(ticker_name)[:price].to_f
      else
        ticker_price = transaction[:ticker_price].to_f
        total_shares += portfolio_entries.fetch(ticker_name)[:total_shares]
      end
      portfolio_entries[ticker_name] = {total_shares: total_shares.to_i, bought_price: transaction[:ticker_price].to_s.to_f, current_price: ticker_price.to_f}
    end
    update_networth(portfolio.id, portfolio_entries)
    return portfolio_entries
  end

  def update_networth(portfolio_id, portfolio_entries)
    portfolio = Portfolio.find(portfolio_id)
    total_networth = 0
    portfolio_entries.each do |key, entry|
      total_networth += (entry[:current_price] * entry[:total_shares])
    end

    if portfolio != nil
      portfolio.total_networth = total_networth
      portfolio.save
    end
  end

  private

  def portfolio_params
    params.permit(:user_id)
  end

end
