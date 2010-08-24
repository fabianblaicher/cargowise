# coding: utf-8

module Cargowise
  class ShipmentsClient < AbstractClient 
    endpoint Cargowise::SHIPMENT_ENDPOINT

    # return an array of shipments. Each shipment should correspond to
    # a consolidated shipment from the freight company.
    #
    def get_shipments_list(company_code, username, pass)
      soap_action = 'http://www.edi.com.au/EnterpriseService/GetShipmentsList'
      soap_headers = headers(company_code, username, pass)
      soap_body    = {"tns:Filter" => { "tns:Status" => "Undelivered"}}
      soap_body    = {"tns:Filter" => { "tns:Number" => {"tns:NumberSearchField" => "ShipmentNumber", "tns:NumberValue" => "S00314298"}}}
      response = invoke('tns:GetShipmentsList', :soap_action => soap_action, :soap_header => soap_headers, :soap_body => soap_body)
      response.document.xpath("//tns:GetShipmentsListResult/tns:WebShipment", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
        Cargowise::Shipment.new(node)
      end
    end

  end
end
