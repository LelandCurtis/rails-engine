class Api::V1::Merchants::FindAllController < ApplicationController
  def index
    if bad_request?
      json_response({data: [], error: "Bad request"}, :bad_request)
    elsif Merchant.find_all(name: query_params[:name]) == []
      json_response({data: [], error: "No merchants found"})
    else
      json_response(MerchantSerializer.new(Merchant.find_all(name: query_params[:name])))
    end
  end

  private

  def query_params
    params.permit(:name)
  end

  def bad_request?
    # no name query /find_all
    # empty name query /find_all?name=
    query_params[:name] == nil ||
      query_params[:name] == ''
  end
end
