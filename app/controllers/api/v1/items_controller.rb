class Api::V1::ItemsController < ApplicationController
  def index
     if params[:merchant_id]
      render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    else  
      render json: ItemSerializer.new(Item.all)      
    end
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item).serializable_hash, status: :created
    else
      serialized_errors = ItemErrorSerializer.new(item).serializable_hash[:data][:attributes]
      render json: serialized_errors, status: :unprocessable_entity
    end
  end

  def update
      item = Item.find(params[:id])
  
      if item.update(item_params)
        serialized_item = render json: ItemSerializer.new(item)
      else
        serialized_errors = ItemErrorSerializer.new(item).serializable_hash[:data][:attributes]
        render json: serialized_errors, status: :not_found
      end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy_invoices
    item.destroy
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
