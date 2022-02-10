class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    # require 'pry'; binding.pry
    # if Item.id_is_valid(params[:id])
    #   require 'pry'; binding.pry
    #   updated_item = Item.update(params[:id], item_params)
    #   if updated_item.save
    #     require 'pry'; binding.pry
    #     render json: ItemSerializer.new(updated_item), status: :ok
    #   else
    #     render status: 404
    #   end
    # else
    #   render status: 404
    # end



    if Item.id_is_valid(params[:id])
      if Merchant.id_is_valid(params[:item][:merchant_id]) && params[:item][:merchant_id]
        item = Item.update(params[:id], item_params)
        render json: ItemSerializer.new(item), status: :ok
      elsif !params[:item][:merchant_id]
        item = Item.update(params[:id], item_params)
        render json: ItemSerializer.new(item), status: :ok
      else
        render status: 404
      end
    else
      render status: 404
    end
  end

  def delete
    render json: Item.destroy(params[:id])
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

end
