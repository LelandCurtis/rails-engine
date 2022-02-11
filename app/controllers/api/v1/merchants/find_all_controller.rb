class Api::V1::Merchants::FindAllController < ApplicationController
  def index
    if bad_request?
      json_response({data: [], error: "Bad request"}, :bad_request)
    elsif Merchants.find_all(query_params) == []
      json_response({data: [], error: "No merchants found"}, :no_content)
    else
      json_response(MerchantSerializer.new(Merchants.find_all(query_params)))
    end
  end

  private

  def query_params
    params.permit(:name)
  end

  def bad_request?
    # no name query /find_all
    # empty name query /find_all?name=
    if query_params[:name] == nil ||
      query_params[:name] == ''
  end
end
