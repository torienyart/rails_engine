class Api::V1::ItemsController < ApplicationController
  def index
     if params[:merchant_id]
      begin
        render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
      rescue ActiveRecord::RecordNotFound => error
        serialized_error = ErrorSerializer.new(error).serializable_hash[:data][:attributes]
        render json: serialized_error, status: :not_found
      end
    else  
      begin
        render json: ItemSerializer.new(Item.all)      
      rescue ActiveRecord::RecordNotFound => error
        serialized_error = ErrorSerializer.new(error).serializable_hash[:data][:attributes]
        render json: serialized_error, status: :not_found
      end
    end
  end

  def show
    begin
      render json: ItemSerializer.new(Item.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => error
      serialized_error = ErrorSerializer.new(error).serializable_hash[:data][:attributes]
      render json: serialized_error, status: :not_found
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      serialized_item = render json: ItemSerializer.new(item).serializable_hash[:data][:attributes]
    else
      serialized_errors = ItemErrorSerializer.new(item).serializable_hash[:data][:attributes]
      render json: serialized_errors, status: :unprocessable_entity
    end
  end

  # def error_messager(to_render)
  #   begin
  #     to_render
  #   rescue ActiveRecord::RecordNotFound => error
  #     serialized_error = ErrorSerializer.new(error).serializable_hash[:data][:attributes]
  #     render json: serialized_error, status: :not_found
  #   end
  # end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
