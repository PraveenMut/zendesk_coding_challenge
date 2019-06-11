## For debugging and testing purposes only
## use binding.pry as entry point to debug in the code
# require 'pry'
require 'formatador'

# The presentational view of the MVC architectural pattern.
# This is a passive view and contains very little logic, aside from
# the show all tickets method.
class ApplicationView
  @@total_pages = nil

  def self.total_number_of_pages=(incoming_data)
    @@total_pages = incoming_data
  end

  def self.welcome_screen
    print "\n\n"
    print "_____                  __          __  \n"
    print "/__  /  ___  ____  ____/ /__  _____/ /__\n"
    print "  / /  / _ \/ __ \/ __  / _ \/ ___/ //_/\n"
    print " / /__/  __/ / / / /_/ /  __(__  ) ,<   \n"
    print "/____/\___/_/ /_/\__,_/\___/____/_/|_|  \n"
    print "\n\n"
    print "Welcome to the Zendesk Ticket Viewer!\n\n"
    print "This program is a lightweight ticket viewer.\n"
    print "It show you how many tickets you have as agent.\n"
    print "To continue, please select one of the options:\n\n"
    print_main_menu()
  end

  def self.print_main_menu
    print "\nInput Options:\n"
    print "\n[v] Enter V to access all tickets\n"
    print "[s] Enter S to show a single ticket by its id\n"
    print "[q] Enter Q to quit the program\n\n"
  end

  def self.load_all_tickets
    print "\nThank you. Loading all tickets"
    sleep(0.5)
    print "."
    sleep(0.25)
    print '.'
    sleep(0.175)
    print ".\n"
  end

  def self.load_single_ticket(ticket_id)
    print "\nThank you. Loading Ticket ID##{ticket_id}"
    sleep(0.5)
    print ' .'
    sleep(0.25)
    print '.'
    sleep(0.175)
    print ".\n"
  end

  def self.show_all_tickets(incoming_ticket_data, page_number)
    if page_number >= @@total_pages
      print "\n You have reached the end!\n"
    elsif page_number <= 1
      print "\n You are the start of the tickets list\n"
    end
    print "\n Page #{page_number}\n"
    Formatador.display_table(incoming_ticket_data, [:id, :submitter_id, :subject, :updated_at, :status])
    print "\nPlease select an option\n"
    print "\n[n] Enter N to go the next page"
    print "\n[p] Enter P to go the previous page"
    print "\n[s] Enter S to show a single ticket by its id"
    print "\n[m] Enter M to go the main menu"
    print "\n[q] Enter Q to quit the program\n\n"
    return 0
  end

  def self.show_ticket_menu
    print "\nEnter Ticket ID\n"
  end

  def self.show_single_ticket(ticket_data)
    print "\nThank you! Here is the ticket:\n"
    print "\nTicket Subject: #{ticket_data[:subject]}\n"
    print "\nTicket Description:\n"
    print "#{ticket_data[:description]}"
    print "\n\nTicket Created: #{ticket_data[:updated_at]} "
    print "\n\nStatus: #{ticket_data[:status]}"
    print "\n------------------------------------"
    print "\n\nWhat would you like to do now?\n"
    print "\n[m] Enter M to return the main menu\n"
    print "[s] Enter A to display another ticket\n"
    print "[q] Enter Q to quit the program\n\n"
    print "------------------------------------\n\n"
  end

  def self.input_error_handler
    print "\nYou have entered an erroneous input. Please try again\n"
  end

  def self.input_error_handler
    print "\nYou have entered an erroneous input. Please try again\n"
  end

  def self.error_handler(message, error_code)
    if !message.nil? || !error_code.nil?
      print "\nSorry! We have encountered an error: #{message} the error code is #{error_code}\n"
      1
    else
      print "\nSorry! An unknown error has occured. Please restart the program.\n"
      -1
    end
  end

  def self.quit_message
    print "\n"
    abort("Thank you for visiting the Zendesk Ticket Viewer. Goodbye!\n\n")
  end
end
