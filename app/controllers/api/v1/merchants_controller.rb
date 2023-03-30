class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if params[:id]
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    elsif params[:item_id]
      item = Item.find(params[:item_id])
      id = item.merchant.id
      render json: MerchantSerializer.new(Merchant.find(id))
    end
  end
end