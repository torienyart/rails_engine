class ErrorSerializer
  include JSONAPI::Serializer
  attribute :message do
    "I'm sorry, but this isn't working...."
  end

  attribute :errors do |error|
    [error.message]
  end

  def self.undefined_object
    {data: {}}
  end

  def self.negative_price_error
    {errors: "Price cannot be less than 0"}
  end

  def self.unprocessable_error
    {errors: "Cannot search by both name and price"}
  end
end
