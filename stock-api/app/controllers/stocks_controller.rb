require 'net/http'

class StocksController < ApplicationController

  def show
    ticker_name = params[:ticker_name]
    response = get_response(ticker_name)

    render :json => response
  end


  def get_stock_price(ticker_name)
    stock_data = get_stock_data(ticker_name)
    if stock_data == nil
      return {error: "Error fetching ticker data.", status: 500}
    elsif stock_data.include?("Error Message")
      return {error: "Invalid ticker name.", status: 500}
    else
      meta_data = stock_data.fetch("Meta Data")
      last_refreshed = meta_data.fetch("3. Last Refreshed")
      time_series_for_last_refreshed = stock_data.fetch("Time Series (1min)")[last_refreshed]
      price = time_series_for_last_refreshed.fetch("4. close")
      return {ticker: ticker_name, price: price, status: 200}
    end
  end

  def get_stock_data(ticker_name)
    response = get_response(ticker_name)
    return JSON.parse(response)
  end

  def get_response(ticker)
    api_key = "C8ULWGL102UUW7ZO"
    function = "TIME_SERIES_INTRADAY"
    ticker_name = ticker
    endpoint = "https://www.alphavantage.co/query?function=#{function}&symbol=#{ticker_name}&interval=1min&apikey=#{api_key}"
    return Net::HTTP.get(URI(endpoint))
  end

end
