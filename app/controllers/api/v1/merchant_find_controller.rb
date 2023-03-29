class Api::V1::MerchantFindController < ApplicationController
  def merchant_show
    merchant = Merchant.name_search(params[:name])

    if merchant.nil?
      render json: ErrorSerializer.undefined_merchant, status: 200
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end