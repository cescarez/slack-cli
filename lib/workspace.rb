require_relative '../test/test_helper'

CONVERSATIONS_LIST_URL = "https://slack.com/api/conversations.list"

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

    @channels = request["channels"].map { |channel| channel["name"] }
  end

  def error_message(response)
    if response.code != 200 || response["ok"] != true
      return "API request failed with error code #{response.code} and #{response["error"]}."
    else
      return response
    end
  end

end


