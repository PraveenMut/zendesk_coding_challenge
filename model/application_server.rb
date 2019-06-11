require 'HTTP'
require 'JSON'
## For debugging and testing purposes only
## use binding.pry as entry point to debug in the code
# require 'pry'

# The Application Model processes and stores the data in a 'makeshift' database.
# Makes data ready to query from the controller.
class ApplicationModel
  @@sanitised_response = nil

  def self.sanitised_response=(tickets_data)
    @@sanitised_response = tickets_data
  end

  def self.retrieve_tickets_data
    @@sanitised_response
  end

  def self.paginator(ary, page_limit=25)
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

  def self.date_formatter(input)
    return input unless input.class == Array

    input.each do |ticket|
      ticket[:updated_at] = ticket[:updated_at].gsub!(/([T])/, " ").gsub!(/([Z])/, "")
    end
    @@sanitised_response = input
    input
  end

  def self.display_readifer(ary)
    ary_of_pure_hashes = []
    ary.each do |hash|
      ary_of_pure_hashes << hash
    end
    ary_of_pure_hashes
  end
end

# The 'server' class that deals with all requests from the external Zendesk API.
# Also handles the requests for the next page, provided by input from the controller.
class RequestHandler
  @@tickets = nil
  @@error_message = nil
  @@is_next_page = true
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
    @@tickets = JSON.parse(http_response, symbolize_names: true)
    @@tickets
  end

  def self.retrieve_single_ticket(ticket_id)
    ticket = api_requester(nil, ticket_id)
    ticket
  end

  def self.retrieve_all_tickets
    api_requester(true)
    @@tickets
  end

  def self.next_page_requester(current_page)
    return [] unless current_page.class == Integer
    
    request_page = ((current_page * 25)/100) + 1
    http_response = HTTP.auth(@@authentication).get(@@req_url + "tickets.json?page=#{request_page}")
    return [] if http_response.status != 200

    parsed_response = JSON.parse(http_response, symbolize_names: true)
    next_page_data = parsed_response[:tickets]
    current_data = ApplicationModel.retrieve_tickets_data
    next_page_data.each do |ticket|
      current_data << ticket
    end
    ApplicationModel.sanitised_response = current_data
    @@is_next_page = false if parsed_response[:next_page].nil?
    true
  end

  def self.next_page_check
    @@is_next_page
  end

  def self.display_readifer(ary=@@sanitised_response)
    ary_of_pure_hashes = []
    ary.each do |hash|
      ary_of_pure_hashes << hash
    end
    ary_of_pure_hashes
  end
end