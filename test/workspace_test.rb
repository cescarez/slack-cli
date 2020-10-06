require_relative 'test_helper'


describe "workspace class" do
  describe "workspace instantiation" do
    it "is an instance of workspace" do
      new_workspace = Workspace.new
      expect(new_workspace).must_be_instance_of Workspace
    end
  end
  describe "load channels" do
    it "loads channels" do

    end

  end
end