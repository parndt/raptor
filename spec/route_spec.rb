require './spec/spec_helper'

describe Raptor::Router do
  it "routes requests through the record, presenter, and template" do
    request = request('/post/5')
    rendered = FakeResources::Post::Routes.call(request)
    rendered.strip.should == "It's FIRST POST!"
  end

  describe "when a route isn't defined" do
    it "raises an error" do
      request = request('/doesnt_exist')
      expect do
        FakeResources::Post::Routes.call(request)
      end.to raise_error(Raptor::NoRouteMatches)
    end
  end

  it "knows when a route matches" do
    FakeResources::Post::Routes.matches?("/post/new").should == true
  end

  it "knows when routes don't match" do
    FakeResources::Post::Routes.matches?("/not_a_post/new").should == false
  end

  describe "default routes" do
    include FakeResources::WithNoBehavior

    it "has an index" do
      request = request('/with_no_behavior')
      Routes.call(request).strip.should match /record 1\s+record 2/
    end

    it "has a show" do
      request = request('/with_no_behavior/2')
      Routes.call(request).strip.should == "record 2"
    end

    it "has a new" do
      request = request('/with_no_behavior/new')
      Routes.call(request).strip.should == "<form></form>"
    end
  end
end

