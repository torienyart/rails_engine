class Api::V1::ItemsFindController < ApplicationController
  def index
    if params[:min_price].to_f < 0 || params[:max_price].to_f < 0
      render json: ErrorSerializer.negative_price_error, status: 400
    elsif params[:name] && (params[:min_price] || params[:max_price])
      render json: ErrorSerializer.unprocessable_error, status: 400
    else
      if params[:name] && !params[:min_price]
        items = Item.name_search(params[:name])
        render json: ItemSerializer.new(items)
      elsif params[:min_price] || params[:max_price] &&!params[:name]
        items = Item.price_search(params[:min_price], params[:max_price])
        render json: ItemSerializer.new(items)
      end
    end
  end
end