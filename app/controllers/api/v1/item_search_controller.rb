class Api::V1::ItemSearchController < ApplicationController
  def index
    if params[:min_price] && !params[:max_price]
      items = Item.search_by_min_price(params[:min_price])
    elsif params[:max_price] && !params[:min_price]
      items = Item.search_by_max_price(params[:max_price])
    elsif params[:min_price] && params[:max_price]
      items = Item.search_by_min_and_max_price(params[:min_price], params[:max_price])
    else
      items = Item.search_items(params[:name])
    end
    render json: ItemSerializer.new(items)
  end
end
