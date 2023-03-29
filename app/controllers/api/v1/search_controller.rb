class Api::V1::SearchController < ApplicationController
  def merchant_show
    Merchant.name_search(params[:name])
    require 'pry'; binding.pry
  end
end