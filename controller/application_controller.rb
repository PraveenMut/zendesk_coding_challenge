require './model/application_server.rb'
require './view/application_view.rb'

# The Controller from MVC architectural pattern.
# Controls the program flow and handles user input.
# Retrieves data from the model, processes it, displaying either a failure message
# or the resultant data to the view.
class ApplicationController
  @@input = nil
  @@page_number = 1
  @forbidden_response = "Authentication failed, check your credentials"
  @not_found_response = "API endpoint access failure"
  @server_error_response = "API unavailable at this time, check again later"
  @unknown_response = "Bad Request. Cannot access API"


  def self.get_input  
    print "Please enter input: "
    @@input = gets().strip
  end

  # retrieves user input and then drives program flow
  def self.menu_control
    running = true
    ApplicationView.welcome_screen
    while running
      get_input()
      if @@input == "v" || @@input == "V"
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
            ApplicationModel.sanitised_response = res["tickets"]
            show_all()
            running = false
          end
      elsif @@input == "s" || @@input == "S"
        select_ticket_menu()
        running = false
      elsif @@input == "q" || @@input == "Q"
        running = false
        ApplicationView.quit_message
      else
        ApplicationView.input_error_handler
        ApplicationView.print_main_menu
      end
    end
  end

  def self.select_ticket_menu
    p "at show ticket menu"
  end

  # a method to show all the tickets and drive program flow for showing all tickets
  def self.show_all
    p "at show all" 
  end

  # a method to show a single ticket and also drive program flow based on user input for a single ticket
  def self.show_single
    p "at show single"
  end

  # the main execution point for the application. This is where it begins.
  def self.run_main      
  end
end

ApplicationController.menu_control