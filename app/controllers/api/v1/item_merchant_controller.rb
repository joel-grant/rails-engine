class Api::V1::ItemMerchantController < ApplicationController
  def index
    item = Item.find(params[:id])
    # require 'pry'; binding.pry
    render json: MerchantSerializer.new(item.merchant)
  end
end
