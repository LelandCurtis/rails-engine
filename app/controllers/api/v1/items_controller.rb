class Api::V1::ItemsController < ApplicationController
  before_action :get_item, only: [:show]

  def index
    json_response(ItemSerializer.new(Item.all))
  end

  def show
    json_response(ItemSerializer.new(@item))
  end

  def create
    json_response(ItemSerializer.new(Item.create!(item_params)))
  end

  private

  def get_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
