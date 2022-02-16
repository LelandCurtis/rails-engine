class ItemsSoldSerializer
  include JSONAPI::Serializer
  attributes :name, :item_count

  # def initialize(data)
  #   {
  #     "data" => data.map do |merchant|
  #       {
  #         "id" => merchant.id.to_s,
  #         "type" => "items_sold",
  #         "attributes" => {
  #           "name" => merchant.name,
  #           "count" => merchant.item_count
  #         }
  #       }
  #     end
  #   }.to_json
  # end

end
