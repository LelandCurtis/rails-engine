class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    if bad_request?
      json_response({data: [], error: "Bad request"}, :bad_request)
    elsif Merchant.by_most_items(query_params[:quantity]) == []
      json_response({data: [], error: "No merchants found"})
    else
      json_response(ItemsSoldSerializer.new(Merchant.by_most_items(query_params[:quantity])))
    end
  end

  private

  def query_params
    params.permit(:quantity)
  end

  def bad_request?
    # no quantity
    # empty name query /find_all?name=
    query_params[:quantity] == nil ||
    query_params[:quantity] == '' ||
    query_params[:quantity].to_i == 0
  end
end
