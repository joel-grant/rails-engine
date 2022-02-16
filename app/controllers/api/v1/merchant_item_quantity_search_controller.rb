class Api::V1::MerchantItemQuantitySearchController < ApplicationController
  def index
    merchants = Merchant.top_merchants_by_item(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end
end
