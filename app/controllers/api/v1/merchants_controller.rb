class Api::V1::MerchantsController < ApplicationController
  def index
    begin
      render json: MerchantSerializer.new(Merchant.all)
    rescue ActiveRecord::RecordNotFound => error
      serialized_error = ErrorSerializer.new(error).serializable_hash[:data][:attributes]
      render json: serialized_error, status: :not_found
    end
  end

  def show
    if params[:id]
      begin
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
      rescue ActiveRecord::RecordNotFound => error
        serialized_error = ErrorSerializer.new(error).serializable_hash[:data][:attributes]
        render json: serialized_error, status: :not_found
      end
    elsif params[:item_id]
      begin
        item = Item.find(params[:item_id])
        id = item.merchant.id
        render json: MerchantSerializer.new(Merchant.find(id))
      rescue ActiveRecord::RecordNotFound => error
        serialized_error = ErrorSerializer.new(error).serializable_hash[:data][:attributes]
        render json: serialized_error, status: :not_found
      end
    end
  end
end