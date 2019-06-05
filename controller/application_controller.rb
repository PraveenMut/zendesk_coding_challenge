require './model/application_server.rb'
require './view/application_view.rb'

class ApplicationController
  @@input = nil    # stores the input extracted from the user
  @@page_number = 1 # stores a default page number, in this case, default it to 1

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



