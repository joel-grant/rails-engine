class Api::V1::ItemMerchantController < ApplicationController
  def index
    item = Item.find(params[:id])
    render json: MerchantSerializer.new(item.merchant)
  end
end
