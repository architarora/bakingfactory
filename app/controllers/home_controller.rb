class HomeController < ApplicationController

  def home
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def search
  	redirect_back(fallback_location: home_path) if params[:query].blank?
    @query = params[:query]
    @customers = Customer.search(@query)
    @items = Item.search(@query)
    @total_hits = @customers.size + @items.size
  end

end