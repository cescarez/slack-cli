require_relative 'test_helper'


describe "workspace class" do

  describe "workspace instantiation" do
    before do
      @new_workspace = Workspace.new
    end

    it "is an instance of workspace" do
      expect(@new_workspace).must_be_instance_of Workspace
    end

    it "establishes the base data structures when instantiated" do
      [:users, :channels].each do |keyword|
        expect(@new_workspace).must_respond_to keyword
      end

      expect(@new_workspace.users).must_be_kind_of Array
      expect(@new_workspace.channels).must_be_kind_of Array
    end

  end

  describe "load channels" do
    before do
      @new_workspace = Workspace.new
    end

    it "loads channels" do
      @new_workspace.load_channels
      expect(@new_workspace.channels).wont_be_empty
    end

  end
end