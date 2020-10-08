require_relative 'test_helper'
require_relative '../lib/user'

describe "User class" do

  describe "instantiation" do

    before do
      @new_user = User.new("some_id", "some_name", "some_name", "blah", ":)")
    end

    it "is an instance of User" do
      expect(@new_user).must_be_instance_of User
    end

    it "establishes the base data structures when instantiated" do
      [:slack_id, :name, :real_name, :status_text, :status_emoji].each do |keyword|
        expect(@new_user).must_respond_to keyword
      end

      expect(@new_user.slack_id).must_be_kind_of String
      expect(@new_user.name).must_be_kind_of String
      expect(@new_user.real_name).must_be_kind_of String
      expect(@new_user.status_text).must_be_kind_of String
      expect(@new_user.status_emoji).must_be_kind_of String
    end

  end

  describe "self.get" do

    before do
      @query = {token: ENV["SLACK_TOKEN"]}
    end

    it "calls Slack API users.list" do
      VCR.use_cassette("get users list") do
        users = User.get(USERS_LIST_URL, query: @query)

        user_names = users["members"].map { |user| user["name"] }

        expect(users.body).wont_be_nil
        expect(users).must_be_instance_of HTTParty::Response

        ["slackbot", "gomezrc1220", "christabot", "christabel.escarez", "waterrachaelapi_proje"].each do |keyword|
          expect(user_names.include?(keyword)).must_equal true
        end
      end
    end

    it "will raise an exception if the search fails" do
      VCR.use_cassette("get users list") do
        expect {
          User.get(USERS_LIST_URL, query: {token: "unauthed test token"})
        }.must_raise SlackApiError
      end
    end

  end

  describe "details" do
    before do
      @new_user = User.new("some_id", "some_name", "some_name", "blah", ":)")
      @details = @new_user.details
    end

    it "returns String" do
      expect(@details).must_be_kind_of String
    end

    it "returns the correct string" do
      expect(@details).must_equal "User id: some_id\nUsername: some_name\nReal name: some_name\nStatus text: blah\nStatus emoji: :)"
    end

  end

  describe "self.list_all" do

    before do
      VCR.use_cassette("get users list") do
        @user_list = User.list_all
      end
    end

    it "populates the array" do
      expect(@user_list).wont_be_empty
    end

    it "@channels is an array of User objects" do
      expect(@user_list).must_be_kind_of Array
      expect(@user_list.all? { |user| user.class == User }).must_equal true
    end

  end

end
