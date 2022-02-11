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
    if Item.id_is_valid(params[:id])
      item = Item.update(params[:id], item_params)
      if item.save
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
