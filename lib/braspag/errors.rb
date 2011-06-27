module Braspag

  class InvalidConnection < Exception ; end
  class InvalidMerchantId < Exception ; end

  class Bill
    class InvalidConnection < Exception ; end
    class IncompleteParams < Exception ; end
    class InvalidOrderId < Exception ; end
    class InvalidCustomerName < Exception ; end
    class InvalidCustomerId < Exception ; end
    class InvalidBoletoNumber < Exception ; end
    class InvalidInstructions < Exception ; end
    class InvalidExpirationDate < Exception ; end
    class InvalidStringFormat < Exception ; end
    class InvalidPost < Exception ; end
    class InvalidPaymentMethod < Exception ; end
    class InvalidAmount < Exception ; end
    class UnknownError < Exception ; end
  end
end
