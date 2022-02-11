class Api::V1::MerchantItemsController < ApplicationController
  before_action :get_merchant

  def index
    if @merchant.items.length == 0
      json_response({message: 'Your query could not be completed', errors: ["Merchant has no items"]}, :not_found)
    else
      json_response(ItemSerializer.new(@merchant.items))
    end
  end

  private

  def get_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
