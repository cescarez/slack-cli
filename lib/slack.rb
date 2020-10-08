#!/usr/bin/env ruby
require 'dotenv'
require_relative 'workspace'

def main
  Dotenv.load

  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new
  workspace.load_users
  workspace.load_channels
  puts "There are #{workspace.channels.length} channels and #{workspace.users.length} users."

  puts "1. list users\n2. list channels\n3. select user\n4. select channel\n5. quit"
  selection = number_validation(gets.chomp, 5)

  while (1..4).include? selection
    case selection
    when 1
      ap workspace.users
    when 2
      ap workspace.channels
    when 3
      puts "Please input a username or slack id"
      selected_user = workspace.select_user(gets.chomp)
      puts "Would you like details?"
      details_selection = input_validation(gets.chomp.downcase)
      if details_selection == "yes"
        puts workspace.show_details(selected_user)
      end
    when 4
      puts "Please input a channel name or slack id"
      selected_channel = workspace.select_channel(gets.chomp)
      puts "Would you like details?"
      details_selection = input_validation(gets.chomp.downcase)
      if details_selection == "yes"
        puts workspace.show_details(selected_channel)
      end

    end

    puts "Make another selection:"
    puts "1. list users\n2. list channels\n3. select user\n4. select channel\n5. quit"
    selection = number_validation(gets.chomp, 5)
  end

  puts "Thank you for using the Ada Slack CLI"
end

def number_validation(input, max_num)
  input = translate_input(input)

  while !(1..max_num).include? input
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