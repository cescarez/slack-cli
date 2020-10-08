#!/usr/bin/env ruby
require 'dotenv'
require 'awesome_print'
require_relative 'workspace'

def main
  Dotenv.load

  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new
  workspace.load_users
  workspace.load_channels
  puts "There are #{workspace.channels.length} channels and #{workspace.users.length} users."

  puts selection_items
  selection = get_selection(gets.chomp)

  while (1..4).include? selection
    case selection
    when 1
      ap workspace.users
    when 2
      ap workspace.channels
    when 3
      puts "Please input a username or slack id"
      selected_user = workspace.select_user(gets.chomp)

      if selected_user
        puts "Would you like details about #{selected_user.real_name}?"
        puts get_details(workspace, selected_user)

        puts "Would you like to send #{selected_user.real_name} a message? (yes/no)"
        send_message(selected_user)
      else
        puts "No user found."
      end
    when 4
      puts "Please input a channel name or slack id"
      selected_channel = workspace.select_channel(gets.chomp)

      if selected_channel
        puts "Would you like details?"
        puts get_details(workspace, selected_channel)

        puts "Would you like to post on the ##{selected_channel.name} channel? (yes/no)"
        send_message(selected_channel)
      else
        puts "No channel found"
      end
    end

    puts "Make another selection:"
    puts selection_items
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
  if instance.class == User
  elsif instance.class == Channel
  end

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