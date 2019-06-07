require 'HTTP'
require 'JSON'

class RequestHandler
  @@tickets = nil
  @@error_message = nil
  @@req_url = "https://praveenmuthu.zendesk.com/api/v2/"
  @@authentication = "Basic cHJhdmVlbi5tdXRAZ21haWwuY29tOkphNHBUOUQzN0RkUFR5OHU4aEZV"

  def self.api_requester(get_all_tickets=nil, id="")
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

class ApplicationModel
  def self.paginator(ary, page_limit)
    return [] unless ary.class == Array

    resultant_ary = []
    number_of_pages = (ary.length.to_f / page_limit.to_f).ceil
    subarray_index = 0
    element_index = 0
    number_of_pages.times do
      resultant_ary << []
    end
    ary.each do |subary|
      if (element_index % page_limit).zero? && element_index.nonzero? && element_index != ary.length
        subarray_index += 1
      end
      resultant_ary[subarray_index] << subary
      element_index += 1
    end
    resultant_ary
  end
end