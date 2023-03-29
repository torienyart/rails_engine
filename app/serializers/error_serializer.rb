class ErrorSerializer
  include JSONAPI::Serializer
  attribute :message do
    "I'm sorry, but this isn't working...."
  end

  attribute :errors do |error|
    [error.message]
  end
end
