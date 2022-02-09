class Api::V1::MerchantSearchController < ApplicationController
  def index
    merchant = Merchant.search_merchant(params[:name])
    render json: MerchantSerializer.new(merchant)
  end
end
