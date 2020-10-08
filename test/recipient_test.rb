require_relative 'test_helper'
require_relative '../lib/recipient'

describe "Recipient class" do

  describe "constructor" do

    before do
      @new_recipient = Recipient.new("test_id", "test_name")
    end

    it "is an instance of Recipent" do
      expect(@new_recipient).must_be_instance_of Recipient
    end

    it "establishes the base data structures when instantiated" do
      expect(@new_recipient.slack_id).must_be_kind_of String
      expect(@new_recipient.name).must_be_kind_of String
    end

    it "correctly assigns instance variables" do
      expect(@new_recipient.slack_id).must_equal "test_id"
      expect(@new_recipient.name).must_equal "test_name"
    end

  end

  describe "self.get" do

    before do
      @users_list_url = "https://slack.com/api/users.list"
      @conversations_list_url = "https://slack.com/api/conversations.list"
      @query = {token: ENV["SLACK_TOKEN"]}
    end


    it "calls Slack API users.list" do
      VCR.use_cassette("get users list") do
        Recipient.get(@users_list_url, query: @query)
      end
    end

    it  "calls Slack API conversations.list" do
      VCR.use_cassette("get conversations list") do
        Recipient.get(@conversations_list_url, query: @query)
      end

    end

    it "will raise an exception if the search fails for user" do
      VCR.use_cassette("users list - failing token") do
        expect {
          Recipient.get(@users_list_url, query: {token: "unauthed test token"})
        }.must_raise SlackApiError
      end
    end

    it "will raise an exception if the search fails for channel" do
      VCR.use_cassette("conversations list - failing token") do
        expect {
          Recipient.get(@conversations_list_url, query: {token: "unauthed test token"})
        }.must_raise SlackApiError
      end
    end

  end

  describe "details" do

    before do
      @new_recipient = Recipient.new("test_id", "test_name")
    end

    it "raises error when called" do
      expect{ @new_recipient.details }.must_raise NotImplementedError
    end
  end

  describe "self.list_all" do
    it "raises error when called" do
      expect { Recipient.list_all }.must_raise NotImplementedError
    end
  end

  describe "self.send_message" do
    before do
      @new_recipient = Recipient.new("test_id", "test_name")
    end

    let :channel_post_params do
      {
        token: ENV['SLACK_TOKEN'],
        channel: "random",
        text: "testing"
      }
    end

    it "posts in a channel" do
      VCR.use_cassette("post in #random channel") do
        @new_recipient.send_message(channel_post_params)
      end
    end


  end

end