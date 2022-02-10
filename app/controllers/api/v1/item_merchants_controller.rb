class Api::V1::ItemMerchantsController < ApplicationController
  before_action :get_item, only: [:index]

  def index
    json_response(MerchantSerializer.new((@item.merchant)))
  end

  private

  def get_item
    @item = Item.find(params[:item_id])
  end
end
