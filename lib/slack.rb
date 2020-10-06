#!/usr/bin/env ruby
require_relative 'workspace'
def main
  puts "Welcome to the Ada Slack CLI!"
  workspace = Workspace.new


  puts "1. list users\n2. list channels\n3. quit"
  selection = input_validation(gets.chomp, 3)

  while selection == 1 || selection == 2
    if selection == 1
      workspace.load_users
      ap workspace.users
    else
      workspace.load_channels
      ap workspace.channels
    end

    puts "Make another selection:"
    puts "1. list users\n2. list channels\n3. quit"
    selection = input_validation(gets.chomp, 3)
  end

  puts "Thank you for using the Ada Slack CLI"
end

def input_validation(input, max_num)
  input = translate_input(input)

  while !(1..max_num).include? input
    puts "Invalid input. Please re-enter a selection."
    input = translate_input(gets.chomp)
  end

  return input
end

def translate_input(string_input)
  case string_input.downcase
  when "list users", "1"
    return 1
  when "list channels", "2"
    return 2
  when "quit", "3"
    return 3
  else
    return string_input
  end
end

main if __FILE__ == $PROGRAM_NAME