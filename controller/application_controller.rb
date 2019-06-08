require './model/application_server.rb'
require './view/application_view.rb'

# The Controller from MVC architectural pattern.
# Controls the program flow and handles user input.
# Retrieves data from the model, processes it, displaying either a failure message
# or the resultant data to the view.
class ApplicationController
  @@current_page = 1
  @@paginated_array = nil
  @forbidden_response = "Authentication failed, check your credentials"
  @not_found_response = "API endpoint access failure"
  @server_error_response = "API unavailable at this time, check again later"
  @unknown_response = "Bad Request. Cannot access API"


  def self.get_input  
    print "Please enter input: "
    input = gets().strip
    input
  end

  # retrieves user input and then drives program flow
  def self.menu_control  
    running = true    
    ApplicationView.welcome_screen
    while running
      if get_input == "v" || get_input == "V"
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
            running = false
            ApplicationModel.sanitised_response = res["tickets"]
            show_all()
          end
      elsif get_input == "s" || get_input == "S"
        running = false
        select_ticket_menu()
      elsif get_input == "q" || get_input == "Q"
        running = false
        ApplicationView.quit_message
      else
        ApplicationView.input_error_handler
        ApplicationView.print_main_menu
      end
    end
  end

  def self.select_ticket_menu
    p "At ticket menu"
    return 0
  end

  # a method to show all the tickets and drive program flow for showing all tickets
  def self.show_all
    page_offset = current_page - 1
    running = true
    @@paginated_array = ApplicationModel.display_readifer(ApplicationModel.retrieve_tickets_data[page_offset])
    total_pages = ApplicationModel.retrieve_tickets_data.length
    while running
      ApplicationView.show_all_tickets(@@paginated_array)
      if get_input == 'N' || get_input == 'n'
        if current_page > total_pages
          ApplicationView.end_of_list = true
        else
          @@current_page += 1
          page_offset += 1
        end
      elsif get_input == 'P' || get_input = 'p'
        if @@current_page = 1
          ApplicationView.start_of_list = true
        else
          @@current_page -= 1
          page_offset -= 1
        end
      elsif get_input == 'q' || get_input == 'Q'
        ApplicationView.quit_message
      elsif get_input == 'm' || get_input == 'M'
        running = false
        menu_control
      else
        ApplicationView.input_error_handler
      end
    end
  end

  # a method to show a single ticket and also drive program flow based on user input for a single ticket
  def self.show_single   
    p "At show single"
    0
  end

  # a method to show a single ticket and also drive program flow based on user input for a single ticket
  def self.run_main
  end
end