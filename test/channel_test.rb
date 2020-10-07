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
        }.must_raise ArgumentError
      end
    end
  end

  describe "details" do

  end

  describe "self.list_all" do
    before do
      @new_channel = Channel.new("some_id", "some_name", "some topic", 300)
      @new_channel.load_channels
      @channel_list = @new_workspace.channels
    end

    it "populates the array" do
      expect(@channel_list).wont_be_empty
    end

    it "@channels is an array of hashes" do
      expect(@channel_list).must_be_kind_of Array
      expect(@channel_list.all? { |channel| channel.class == Hash }).must_equal true
    end

    it "correctly loads list of channels" do
      current_channels = ["general", "random", "slackcli"]
      expect(@channel_list.each { |channel| current_channels.include?(channel[:name]) })
      expect(@channel_list.length).must_equal 3
    end
  end

end