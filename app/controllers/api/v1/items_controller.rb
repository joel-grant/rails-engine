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
    if !Item.where(id: params[:id]).empty?
      if params[:item][:merchant_id]
        if !Merchant.where(id: params[:item][:merchant_id]).empty?
          item = Item.update(params[:id], item_params)
          render json: ItemSerializer.new(item)
        else
          render status: 400
        end
      else
        item = Item.update(params[:id], item_params)
        render json: ItemSerializer.new(item)
      end
    else
      render status: 404
    end
    # Original Solution
    # if Item.where(id: params[:id]).empty? # Make a method for this
    #   render status: 404
    # else
    #   item = Item.update(params[:id], item_params)
    #   render json: ItemSerializer.new(item)
    # end
  end

  def delete
    render json: Item.delete(params[:id])
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

end
