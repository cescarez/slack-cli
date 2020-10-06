require_relative '../test/test_helper'

CONVERSATIONS_LIST_URL = "https://slack.com/api/conversations.list"
USERS_LIST_URL = "https://slack.com/api/users.list"

class Workspace
  attr_reader :users, :channels
  def initialize
    @users = []
    @channels = []
  end

  def load_channels
    query = {
      token: ENV['SLACK_TOKEN']
    }

    request = error_message(HTTParty.get(CONVERSATIONS_LIST_URL, query: query))

    raise ArgumentError, request if request.class == String

    #README specifies "name, topic, member count, and Slack ID"; topic interpreted as 'purpose'
    @channels = request["channels"].map do |channel|
      { name: channel["name"],
        topic: channel["purpose"]["value"],
        member_count: channel["num_members"],
        id: channel["id"] }
    end
  end

  def load_users
    query = {
        token: ENV['SLACK_TOKEN']
    }

    request = error_message(HTTParty.get(USERS_LIST_URL, query: query))

    raise ArgumentError, request if request.class == String

    @users = request["members"].map do |user|
      { name: user["name"],
        real_name: user["real_name"],
        id: user["id"] }
    end
  end


  def error_message(response)
    if response.code != 200 || response["ok"] != true
      return "API request failed with error code #{response.code} and #{response["error"]}."
    else
      return response
    end
  end

end


