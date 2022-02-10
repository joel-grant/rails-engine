class Api::V1::MerchantSearchController < ApplicationController
  def index
    merchant = Merchant.search_merchant(params[:name])
    if merchant == nil 
      render json: MerchantSerializer.new(Merchant.create())
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
