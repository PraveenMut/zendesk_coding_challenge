require 'HTTP'
require 'JSON'


class RequestHandler
  attr_reader :error_message
  @@tickets = nil
  @@error_message = nil
  @@req_url = "https://praveenmuthu.zendesk.com/api/v2/"
  @@authentication = "Basic cHJhdmVlbi5tdXRAZ21haWwuY29tOkphNHBUOUQzN0RkUFR5OHU4aEZV"

  def self.api_requester(get_all_tickets=nil, id="")
    forbidden_response = "Authentication failed, check your credentials"
    not_found_response = "API endpoint access failure"
    server_error_response = "API unavailable at this time, check again later"
    unknown_response = "Cannot access API"
    if get_all_tickets
      http_response = HTTP.auth(@@authentication).get(@@req_url + "tickets.json")
    else
      http_response = HTTP.auth(@@authentication).get(@@req_url + id.to_s + ".json")
    end
    if http_response.status != 200
      @@error_message = http_response.status # store the error in a variable for future reference
      if @@error_message == 401
        return forbidden_response
      elsif @@error_message == 404
        return not_found_response
      elsif @@error_message == 503
        return server_error_response
      else
        return unknown_response
      end
    end
    @@tickets = JSON.parse(http_response)
    return @@tickets
  end

  def self.get_single_ticket(ticket_id)
    api_requester(nil, ticket_id)
  end
end

RequestHandler.api_requester(true)
