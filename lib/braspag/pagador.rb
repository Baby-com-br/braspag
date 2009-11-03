module Braspag
  class Pagador < Handsoap::Service
    BASE_ACTION_URL = "https://www.pagador.com.br/webservice/pagador"

    def initialize(connection)
      @connection = connection
      configure_endpoint
    end

    def on_create_document(doc)
      doc.alias 'tns', BASE_ACTION_URL
    end

    def on_response_document(doc)
      doc.add_namespace 'ns', BASE_ACTION_URL
    end

    private
    def configure_endpoint
      self.class.endpoint :uri => "#{@connection.base_url}/webservice/pagador.asmx",
                          :version => 2
    end
  end
end
