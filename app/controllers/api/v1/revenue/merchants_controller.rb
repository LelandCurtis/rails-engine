class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    @merchants = MerchantNameRevenueSerializer.new(Merchant.with_most_revenue(params[:quantity]))
  end
end
