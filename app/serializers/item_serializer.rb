class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price

  attribute :merchant_id do |object|
    object.merchant_id
  end
end
