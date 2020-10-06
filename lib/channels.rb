class Channel



  def channel_name_list
    query = {
        token: ENV["SLACK_TOKEN"]
    }

    request = HTTParty.get(CONVERSATIONS_LIST_URL, query: query)

    if request.code != 200 || request["ok"] != true
      return "API request failed with error code #{request.code} and #{request["error"]}."
    else
      channel_names = request["channels"].map { |channel| channel["name"] }
      return channel_names
    end
  end
end