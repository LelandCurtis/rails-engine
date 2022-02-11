class Api::V1::Items::FindController < ApplicationController
  def show
    if bad_request?
      json_response({data: [], error: "Bad request"}, :bad_request)
    elsif Item.search(query_params) == []
      json_response({data: {id: nil, type: "item", attributes: []}, error: "No records found"})
    else
      json_response(ItemSerializer.new(Item.search(query_params)))
    end
  end

  private

  def query_params
    #collect query params if they exist
    q_params = {}
    q_params[:name] = params[:name] if params[:name]
    q_params[:min_price] = params[:min_price] if params[:min_price]
    q_params[:max_price] = params[:max_price] if params[:max_price]

    q_params
  end

  def not_number?(string)
    false if Float(string) rescue true
  end

  def bad_request?
    # check for unacceptable queries
    # missing all parameters
    # empty parameters
    # both name and either or both price parameters
    # negative values for min or max price
    # non-number values for min/max price

    return true if not_number?(query_params[:min_price]) && query_params[:min_price] != nil
    return true if not_number?(query_params[:max_price]) && query_params[:max_price] != nil
    query_params.keys.length == 0 ||
    query_params.values.include?('') ||
    [:name, :min_price].all?{|key| query_params.keys.include?(key)} ||
    [:name, :max_price].all?{|key| query_params.keys.include?(key)} ||
    query_params[:min_price] != nil && Float(query_params[:min_price]) < 0 ||
    query_params[:max_price] != nil && Float(query_params[:max_price]) < 0 ||
    query_params[:min_price] != nil && query_params[:max_price] != nil && Float(query_params[:min_price]) > Float(query_params[:max_price])
  end
end
