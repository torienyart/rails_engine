class Api::V1::ItemsFindController < ApplicationController
  def index
    
    if params[:name] && !params[:min_price]
      items = Item.name_search(params[:name])
      if items.nil?
        render json: ErrorSerializer.undefined_object, status: 200
      else
        render json: ItemSerializer.new(items)
      end
    elsif params[:min_price] || params[:max_price] &&!params[:name]
      items = Item.price_search(params[:min_price], params[:max_price])
      if items.nil?
        render json: ErrorSerializer.undefined_object, status: 200
      else
        render json: ItemSerializer.new(items)
      end
    end

  end
end