require 'faraday'
require 'datmachine/error'

# @api private
module Faraday

  class Response::RaiseDatmachineError < Response::Middleware

    HTTP_STATUS_CODES = {
        300 => Datmachine::MoreInformationRequired,
        400 => Datmachine::BadRequest,
        401 => Datmachine::Unauthorized,
        402 => Datmachine::PaymentRequired,
        403 => Datmachine::Forbidden,
        404 => Datmachine::NotFound,
        405 => Datmachine::MethodNotAllowed,
        409 => Datmachine::Conflict,
        410 => Datmachine::Gone,
        500 => Datmachine::InternalServerError,
        501 => Datmachine::NotImplemented,
        502 => Datmachine::BadGateway,
        503 => Datmachine::ServiceUnavailable,
        504 => Datmachine::GatewayTimeout,
    }

    def on_complete(response)
      status_code = response[:status].to_i
      error_class = CATEGORY_CODE_MAP[category_code] || HTTP_STATUS_CODES[status_code]
      raise error_class.new(response) if error_class
    end

  end

end