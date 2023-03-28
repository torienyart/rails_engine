class ItemErrorSerializer
  include JSONAPI::Serializer
  attribute :message do
    "Your item couldn't be created."
  end

  attribute :errors do |item|
    errors = item.errors.map do |error|
      error.full_message
    end
  end
end
