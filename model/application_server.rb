require 'HTTP'
require 'JSON'


class RequestHandler
  @@tickets = nil
  @@error_message = nil
  @@req_url = "https://praveenmuthu.zendesk.com/api/v2/"
  @@authentication = "Basic cHJhdmVlbi5tdXRAZ21haWwuY29tOkphNHBUOUQzN0RkUFR5OHU4aEZV"

  def self.api_requester(get_all_tickets=nil, id="")
    # forbidden_response = "Authentication failed, check your credentials"
    # not_found_response = "API endpoint access failure"
    # server_error_response = "API unavailable at this time, check again later"
    # unknown_response = "Cannot access API"
    if get_all_tickets
      http_response = HTTP.auth(@@authentication).get(@@req_url + "tickets.json")
    else
      http_response = HTTP.auth(@@authentication).get(@@req_url + "tickets/" + id.to_s + ".json")
    end
    if http_response.status != 200
      @@error_message = http_response.status # store the error in a variable for future reference
      if @@error_message == 401
        return 401
      elsif @@error_message == 404
        return 404
      elsif @@error_message == 503
        return 503
      else
        return 400
      end
    end
    @@tickets = JSON.parse(http_response)
    return @@tickets
  end

  def self.retrieve_single_ticket(ticket_id)
    ticket = api_requester(nil, ticket_id)
    return ticket
  end

  def self.retrieve_all_tickets
    api_requester(true)
    return @@tickets
  end
end
