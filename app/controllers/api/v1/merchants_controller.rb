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
    begin
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => error
      serialized_error = ErrorSerializer.new(error).serializable_hash[:data][:attributes]
      render json: serialized_error, status: :not_found
    end
  end
end