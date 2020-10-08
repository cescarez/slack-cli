require_relative 'test_helper'
require_relative '../lib/channel'

describe "Channel class" do

  describe "instantiation" do

    before do
      @new_channel = Channel.new("some_id", "some_name", "some topic", 300)
    end

    it "is an instance of Channel" do
      expect(@new_channel).must_be_instance_of Channel
    end

    it "establishes the base data structures when instantiated" do
      [:slack_id, :name, :topic, :member_count].each do |keyword|
        expect(@new_channel).must_respond_to keyword
      end

      expect(@new_channel.slack_id).must_be_kind_of String
      expect(@new_channel.name).must_be_kind_of String
      expect(@new_channel.topic).must_be_kind_of String
      expect(@new_channel.member_count).must_be_kind_of Integer
    end

  end

  describe "self.get" do

    before do
      @query = {token: ENV["SLACK_TOKEN"]}
    end

    it "calls Slack API conversations.list" do
      VCR.use_cassette("get conversations list") do
        conversations = Channel.get(CONVERSATIONS_LIST_URL, query: @query)

        channel_names = conversations["channels"].map { |channel| channel["name"] }

        expect(conversations.body).wont_be_nil
        expect(conversations).must_be_instance_of HTTParty::Response

        ["random", "slackcli", "general"].each do |keyword|
          expect(channel_names.include?(keyword)).must_equal true
        end
      end
    end

    it "will raise an exception if the search fails" do
      VCR.use_cassette("get conversations list") do
        expect {
          Channel.get(CONVERSATIONS_LIST_URL, query: {token: "unauthed test token"})
        }.must_raise SlackApiError
      end
    end

  end

  describe "details" do
    before do
      @new_channel = Channel.new("some_id", "some_name", "some topic", 300)
      @details = @new_channel.details
    end

    it "returns String" do
      expect(@details).must_be_kind_of String
    end
    it "returns the correct string" do
      expect(@details).must_equal "Channel id: some_id\nChannel name: some_name\nTopic: some topic\nNumber of members: 300"
    end

  end

  describe "self.list_all" do

    before do
      VCR.use_cassette("get conversations list") do
        @channel_list = Channel.list_all
      end
    end

    it "populates the array" do
      expect(@channel_list).wont_be_empty
    end

    it "@channels is an array of Channel objects" do
      expect(@channel_list).must_be_kind_of Array
      expect(@channel_list.all? { |channel| channel.class == Channel }).must_equal true
    end

  end

end