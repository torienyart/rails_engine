class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_response

  def error_response(error)
    serialized_error = ErrorSerializer.new(error).serializable_hash[:data][:attributes]
    render json: serialized_error, status: :not_found
  end
end
