class Api::V1::MerchantItemsController < ApplicationController
  before_action :get_merchant

  def index
      json_response(ItemSerializer.new(@merchant.items))
  end

  private

  def get_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
