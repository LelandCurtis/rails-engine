class Api::V1::ItemsController < ApplicationController
  before_action :get_item, only: [:show, :update, :delete]

  def index
    json_response(ItemSerializer.new(Item.all), :ok)
  end

  def show
    json_response(ItemSerializer.new(@item), :ok)
  end

  def create
    json_response(ItemSerializer.new(Item.create!(item_params)), :created)
  end

  def update
    if @item.update(item_params)
      json_response(ItemSerializer.new(@item), :ok)
    else
      json_response(@item.errors.full_messages.to_sentence, :not_found)
    end
  end

  def destroy
    Item.destroy(params[:id])
  end

  private

  def get_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
