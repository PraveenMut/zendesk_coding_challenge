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

  def self.menu_control   # retrieves user input and then drives program flow
    
  end

  def self.show_all      # a method to show all the tickets and drive program flow for showing all tickets
  end

  def self.show_single   # a method to show a single ticket and also drive program flow based on user input for a single ticket
  end

  def self.run_main      # the main execution point for the application. This is where it begins.
  end
end
