require './model/application_server.rb'
require './view/application_view.rb'
## For debugging and testing purposes only
## use binding.pry as entry point to debug in the code
# require 'pry'

# The Controller from MVC architectural pattern.
# Controls the program flow and handles user input.
# Retrieves data from the model, processes it, displaying either a failure message
# or the resultant data to the view.
class ApplicationController
  @@input = nil
  @@current_page = 1
  @@paginated_array = nil
  @forbidden_response = "Authentication failed, check your credentials"
  @not_found_response = "API endpoint access failure"
  @server_error_response = "API unavailable at this time, check again later"
  @unknown_response = "Bad Request. Cannot access API"


  def self.get_input  
    print "Please enter input: "
    @@input = gets.strip
  end

  # retrieves user input and then drives program flow
  def self.menu_control
    @@current_page = 1
    RequestHandler.set_is_next_page = true
    ApplicationView.welcome_screen
    while true
      get_input()
      if @@input == "v" || @@input == "V"
        ApplicationView.load_all_tickets
        res = RequestHandler.retrieve_all_tickets()
          if res == 401
            ApplicationView.error_handler(@forbidden_response, res)
          elsif res == 404
            ApplicationView.error_handler(@not_found_response, res)
          elsif res == 503
            ApplicationView.error_handler(@server_error_response, res)
          elsif res == 400
            ApplicationView.error_handler(@unknown_response, res)
          else
            ApplicationModel.date_formatter(res[:tickets])
            paginate_tickets
            return false
          end
      elsif @@input == "s" || @@input == "S"
        select_ticket_menu
        return false
      elsif @@input == "q" || @@input == "Q"
        ApplicationView.quit_message
      else
        ApplicationView.input_error_handler
        ApplicationView.print_main_menu
      end
    end
  end

  def self.select_ticket_menu(in_testing=false, ticket_id=nil)
    @@input = nil
    ApplicationView.show_ticket_menu
    get_input
    ApplicationView.load_single_ticket(@@input)
    res = RequestHandler.retrieve_single_ticket(@@input)
    res = RequestHandler.retrieve_single_ticket(ticket_id) if in_testing == true

    if res == 401
      ApplicationView.error_handler(@forbidden_response, res)
      return 1 if in_testing == true

      select_ticket_menu
    elsif res == 503
      ApplicationView.error_handler(@server_error_response, res)
      return 1 if in_testing == true

      select_ticket_menu
    elsif res == 404
      ApplicationView.error_handler("Invalid Ticket ID, please enter again", "not found")
      return -1 if in_testing == true
      
      select_ticket_menu
    elsif res == 400 || res.class != Hash
      ApplicationView.error_handler(@unknown_response, res)
      return 1 if in_testing == true

      select_ticket_menu
    else
      ApplicationModel.sanitised_response = res[:ticket]
      show_single
      return 0
    end
  end

  def self.paginate_tickets
    @@paginated_array = ApplicationModel.paginator(ApplicationModel.retrieve_tickets_data, 25)
    ApplicationView.total_number_of_pages = @@paginated_array.length
    show_all
  end

  # a method to show all the tickets and drive program flow for showing all tickets
  def self.show_all
    @@input = nil
    @@current_page = 1 if @@current_page < 1
    if @@current_page == @@paginated_array.length && RequestHandler.next_page_check
      RequestHandler.next_page_requester(@@current_page)
      paginate_tickets 
    end
    @@current_page = @@paginated_array.length if @@current_page > @@paginated_array.length

    page_offset = @@current_page - 1
    current_ticket_data = ApplicationModel.display_readifer(@@paginated_array[page_offset])
    ApplicationView.show_all_tickets(current_ticket_data, @@current_page)
    get_input
    if @@input == 'N' || @@input == 'n'
      @@current_page += 1
      show_all
    elsif @@input == 'P' || @@input == 'p'
      @@current_page -= 1
      show_all
    elsif @@input == 'S' || @@input == 's'
      select_ticket_menu
    elsif @@input == 'M' || @@input == 'm'
      menu_control
    elsif @@input == 'Q' || @@input == 'q'
      ApplicationView.quit_message
    else
      ApplicationView.input_error_handler
      show_all
    end
  end

  # a method to show a single ticket and also drive program flow based on user input for a single ticket
  def self.show_single(in_testing=false)
    @@input = nil
    ticket_data = ApplicationModel.retrieve_tickets_data
    ApplicationView.show_single_ticket(ticket_data)
    return ticket_data if in_testing == true

    get_input
    if @@input == 'M' || @@input == 'm'
      menu_control
    elsif @@input == 'A' || @@input == 'a'
      select_ticket_menu
    elsif @@input == 'Q' || @@input == 'q'
      ApplicationView.quit_message
    else
      ApplicationView.input_error_handler
      show_single
    end
  end

  # the main execution point for the application. This is where the magic begins.
  def self.run_main
   menu_control
  end
end

ApplicationController.run_main