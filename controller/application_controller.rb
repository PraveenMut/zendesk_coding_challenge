require './model/application_server.rb'
require './view/application_view.rb'

# The Controller from MVC architectural pattern.
# Controls the program flow and handles user input.
# Retrieves data from the model, processes it, displaying either a failure message
# or the resultant data.
class ApplicationController
  @@input = nil
  @@page_number = 1

  def get_input  
    print "Please enter input: "
    @@input = gets().strip
  end

  def sanitiser   # sanitises input from the model and passes any errors to the view # if there are not any errors, pass this any other dependent methods (paginator or single ticket show)            
  end

  def paginator(ary)  # divides the incoming array into the desired amount of subarrays.
  end

  def menu_control   # retrieves user input and then drives program flow
  end

  def show_all      # a method to show all the tickets and drive program flow for showing all tickets
  end

  def show_single   # a method to show a single ticket and also drive program flow based on user input for a single ticket
  end

  def run_main      # the main execution point for the application. This is where it begins.
  end
end
