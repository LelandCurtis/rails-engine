class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    @merchants = MerchantNameRevenueSerializer.new(Merchant.with_most_revenue(query_params[:quantity]))
  end

  private

  def query_params
    params.permit(:quantity)
  end
end
