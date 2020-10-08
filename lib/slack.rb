#!/usr/bin/env ruby
require 'dotenv'
require 'table_print'
require_relative 'workspace'

def main
  Dotenv.load

  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new
  workspace.load_users
  workspace.load_channels
  puts "There are #{workspace.channels.length} channels and #{workspace.users.length} users."

  puts selection_items
  print "Please make a selection: "
  selection = get_selection(gets.chomp)

  while (1..4).include? selection
    case selection
    when 1
      tp workspace.users, "name", "slack_id", "real_name", "status_text", "status_emoji"
    when 2
      tp workspace.channels, "name", "slack_id", "topic", "member_count"
    when 3, 4
      print "Please input a name or Slack ID: "
      input = gets.chomp

      if selection == 3
        selected_recipient = workspace.select_user(input)
      else
        selected_recipient = workspace.select_channel(input)
      end

      if selected_recipient
        print "Would you like details about the #{selected_recipient.class.to_s.downcase} '#{selected_recipient.name}'? (yes/no): "
        puts get_details(workspace, selected_recipient)

        print "Would you like to #{selected_recipient.class == User ? "send a message to " : "post a message on #"}#{selected_recipient.name}? (yes/no): "
        send_message(selected_recipient)
      else
        puts "Nothing found with search term '#{input}'."
      end
    end

    puts selection_items
    print "Make another selection: "
    selection = get_selection(gets.chomp)
  end

  puts "Thank you for using the Ada Slack CLI"
end

def selection_items
  return "1. list users\n2. list channels\n3. select user\n4. select channel\n5. quit"
end

def get_details(workspace, instance)
  details_selection = input_validation(gets.chomp.downcase)

  if details_selection == "yes"
    return workspace.show_details(instance)
  end
end

def send_message(instance)
  message_selection = input_validation(gets.chomp.downcase)

  if message_selection == "yes"
    puts "Please enter your message:"
    message = gets.chomp
    instance.send_message(message)
  end
end

def get_selection(input)
  input = translate_input(input)

  unless (1..5).include? input
    puts "Invalid input. Please re-enter a selection."
    input = translate_input(gets.chomp)
  end

  return input
end

def input_validation(input)
  until ["yes", "no"].include? input
    puts "Invalid input. Please re-enter either a yes or no."
    input = gets.chomp.downcase
  end
  return input
end

def translate_input(string_input)
  case string_input.downcase
  when "list users", "1"
    return 1
  when "list channels", "2"
    return 2
  when "select user", "3"
    return 3
  when "select channel", "4"
    return 4
  when "quit", "5"
    return 5
  else
    return string_input
  end
end

main if __FILE__ == $PROGRAM_NAME