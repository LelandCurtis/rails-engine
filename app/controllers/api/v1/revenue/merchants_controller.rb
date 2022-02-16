class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if query_params[:quantity].to_i == 0
      json_response({data: [], error: 'Invalid quantity. Try inputting a valid integer'}, :bad_request)
    elsif Merchant.with_most_revenue(query_params[:quantity]) == []
      json_response(MerchantNameRevenueSerializer.new([]), :not_found)
    else
      json_response(MerchantNameRevenueSerializer.new(Merchant.with_most_revenue(query_params[:quantity])), :ok)
    end
  end

  private
  def query_params
    params.permit(:quantity)
  end
end
