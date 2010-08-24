# coding: utf-8

module Cargowise
  class AbstractClient < Handsoap::Service
    def on_create_document(doc)
      doc.alias 'tns', Cargowise::DEFAULT_NS
    end

    def on_response_document(doc)
      doc.add_namespace 'ns', Cargowise::DEFAULT_NS
    end

    # test authentication, returns a string with your company name
    # if successful
    #
    def hello(company_code, username, pass)
      soap_action  = 'http://www.edi.com.au/EnterpriseService/Hello'
      soap_headers = headers(company_code, username, pass)
      response = invoke('tns:Hello', :soap_action => soap_action, :soap_header => soap_headers)
      response.document.xpath("//tns:HelloResponse/tns:HelloResult/text()", {"tns" => Cargowise::DEFAULT_NS}).to_s
    end

    private

    def headers(company_code, username, pass)
      {
        "tns:WebTrackerSOAPHeader" => {
          "tns:CompanyCode" => company_code,
          "tns:UserName"    => username,
          "tns:Password"    => pass
        }
      }
    end

  end
end
