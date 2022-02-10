class Api::V1::Items::FindController < ApplicationController
  def show
    json_response(ItemSerializer.new(Item.search(query_params)))
  end

  private

  def query_params
    #params.permit(:name, :min_price, :max_price)
    q_params = {}
    q_params[:name] = params[:name] if params[:name]
    q_params[:min_price] = params[:min_price] if params[:min_price]
    q_params[:max_price] = params[:max_price] if params[:max_price]
    q_params
  end
end
