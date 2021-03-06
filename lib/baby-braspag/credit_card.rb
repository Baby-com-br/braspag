module Braspag
  class CreditCard < PaymentMethod
    MAPPING = {
      :merchant_id => "merchantId",
      :order => 'order',
      :order_id => "orderId",
      :customer_name => "customerName",
      :amount => "amount",
      :payment_method => "paymentMethod",
      :holder => "holder",
      :card_number => "cardNumber",
      :expiration => "expiration",
      :security_code => "securityCode",
      :number_payments => "numberPayments",
      :type => "typePayment"
    }

    AUTHORIZE_URI = "/webservices/pagador/Pagador.asmx/Authorize"
    CAPTURE_URI = "/webservices/pagador/Pagador.asmx/Capture"
    PARTIAL_CAPTURE_URI = "/webservices/pagador/Pagador.asmx/CapturePartial"
    CANCELLATION_URI = "/webservices/pagador/Pagador.asmx/VoidTransaction"
    PRODUCTION_INFO_URI   = "/webservices/pagador/pedido.asmx/GetDadosCartao"
    HOMOLOGATION_INFO_URI = "/pagador/webservice/pedido.asmx/GetDadosCartao"
    STATUS_URI = "/webservices/pagador/pedido.asmx/GetDadosPedido"

    def self.authorize(params = {})
      connection = Braspag::Connection.instance
      params[:merchant_id] = connection.merchant_id

      check_params(params)

      data = {}
      MAPPING.each do |k, v|
        case k
        when :payment_method
          data[v] = Braspag::Connection.instance.homologation? ? PAYMENT_METHODS[:braspag] : PAYMENT_METHODS[params[:payment_method]]
        when :amount
          data[v] = Utils.convert_decimal_to_string(params[:amount])
        else
          data[v] = params[k] || ""
        end
      end

      response = Braspag::Poster.new(authorize_url).do_post(:authorize, data)

      Utils::convert_to_map(response.body, {
        :amount => nil,
        :number => "authorisationNumber",
        :message => 'message',
        :return_code => 'returnCode',
        :status => 'status',
        :transaction_id => "transactionId"
      })
    end

    def self.capture(order_id)
      connection = Braspag::Connection.instance
      merchant_id = connection.merchant_id

      raise InvalidOrderId unless self.valid_order_id?(order_id)

      data = {
        MAPPING[:order_id] => order_id,
        MAPPING[:merchant_id] => merchant_id
      }

      response = Braspag::Poster.new(capture_url).do_post(:capture, data)

      Utils::convert_to_map(response.body, {
        :amount => nil,
        :number => "authorisationNumber",
        :message => 'message',
        :return_code => 'returnCode',
        :status => 'status',
        :transaction_id => "transactionId"
      })
    end

    def self.partial_capture(order_id, amount)
      connection = Braspag::Connection.instance
      merchant_id = connection.merchant_id

      raise InvalidOrderId unless self.valid_order_id?(order_id)

      data = {
        MAPPING[:order_id] => order_id,
        MAPPING[:merchant_id] => merchant_id,
        "captureAmount" => Utils.convert_decimal_to_string(amount)
      }

      response = Braspag::Poster.new(partial_capture_url).do_post(:partial_capture, data)

      Utils::convert_to_map(response.body, {
        :amount => nil,
        :number => "authorisationNumber",
        :message => 'message',
        :return_code => 'returnCode',
        :status => 'status',
        :transaction_id => "transactionId"
      })
    end

    def self.void(order_id)
      connection = Braspag::Connection.instance
      merchant_id = connection.merchant_id

      raise InvalidOrderId unless self.valid_order_id?(order_id)

      data = {
        MAPPING[:order] => order_id,
        MAPPING[:merchant_id] => merchant_id
      }

      response = Braspag::Poster.new(cancellation_url).do_post(:void, data)

      Utils::convert_to_map(response.body, {
        :amount => nil,
        :number => "authorisationNumber",
        :message => 'message',
        :return_code => 'returnCode',
        :status => 'status',
        :transaction_id => "transactionId"
      })
    end

    def self.info(order_id)
      connection = Braspag::Connection.instance

      raise InvalidOrderId unless self.valid_order_id?(order_id)

      data = {:loja => connection.merchant_id, :numeroPedido => order_id.to_s}
      response = Braspag::Poster.new(info_url).do_post(:info_credit_card, data)

      response = Utils::convert_to_map(response.body, {
        :checking_number => "NumeroComprovante",
        :certified => "Autenticada",
        :autorization_number => "NumeroAutorizacao",
        :card_number => "NumeroCartao",
        :transaction_number => "NumeroTransacao"
      })

      raise UnknownError if response[:checking_number].nil?
      response
    end

    def self.status(order_id)
      connection = Braspag::Connection.instance

      raise InvalidOrderId unless self.valid_order_id?(order_id)

      data = { :numeroPedido => order_id, :loja => connection.merchant_id }

      response = Braspag::Poster.new(status_url).do_post(:order_status, data)

      Utils::convert_to_map(response.body, {
        :authorization_code => "CodigoAutorizacao",
        :payment_code => "CodigoPagamento",
        :payment_method => "FormaPagamento",
        :installments => "NumeroParcelas",
        :status => "Status",
        :value => "Valor",
        :payment_date => "DataPagamento",
        :order_date => "DataPedido",
        :transaction_id => "TransId",
        :error_code => "CodigoErro",
        :error_message => "MensagemErro"
      })
    end

    # <b>DEPRECATED:</b> Please use <tt>ProtectedCreditCard.save</tt> instead.
    def self.save(params)
      warn "[DEPRECATION] `CreditCard.save` is deprecated.  Please use `ProtectedCreditCard.save` instead."
      ProtectedCreditCard.save(params)
    end

    # <b>DEPRECATED:</b> Please use <tt>ProtectedCreditCard.get</tt> instead.
    def self.get(just_click_key)
      warn "[DEPRECATION] `CreditCard.get` is deprecated.  Please use `ProtectedCreditCard.get` instead."
      ProtectedCreditCard.get(just_click_key)
    end

    # <b>DEPRECATED:</b> Please use <tt>ProtectedCreditCard.just_click_shop</tt> instead.
    def self.just_click_shop(params = {})
      warn "[DEPRECATION] `CreditCard.just_click_shop` is deprecated.  Please use `ProtectedCreditCard.just_click_shop` instead."
      ProtectedCreditCard.just_click_shop(params)
    end

    class << self
      private

      def check_params(params)
        super

        [:customer_name, :holder, :card_number, :expiration, :security_code, :number_payments, :type].each do |param|
          raise IncompleteParams if params[param].nil?
        end

        raise InvalidHolder if params[:holder].to_s.size < 1 || params[:holder].to_s.size > 100

        matches = params[:expiration].to_s.match /^(\d{2})\/(\d{2,4})$/
        raise InvalidExpirationDate unless matches

        year = matches[2].size == 4 ? matches[2] : "20#{matches[2]}"
        raise if !Date.valid_date?(year.to_i, matches[1].to_i, 1)

        raise InvalidSecurityCode if params[:security_code].to_s.size < 1 || params[:security_code].to_s.size > 4

        raise InvalidNumberPayments if params[:number_payments].to_i < 1 || params[:number_payments].to_i > 99
      end

      def authorize_url
        Braspag::Connection.instance.braspag_url + AUTHORIZE_URI
      end

      def capture_url
        Braspag::Connection.instance.braspag_url + CAPTURE_URI
      end

      def partial_capture_url
        Braspag::Connection.instance.braspag_url + PARTIAL_CAPTURE_URI
      end

      def cancellation_url
        Braspag::Connection.instance.braspag_url + CANCELLATION_URI
      end

      def info_url
        connection = Braspag::Connection.instance
        connection.braspag_url + (connection.production? ? PRODUCTION_INFO_URI : HOMOLOGATION_INFO_URI)
      end

      def status_url
        Braspag::Connection.instance.braspag_url + STATUS_URI
      end
    end
  end
end
