require 'spec_helper'

describe ReportServiceHelper do
  context "email sanitizer" do
    it "should convert the at sign in an email" do
      sanitize_email("test@test").should == "test-at-test"
    end
    
    it "should convert the dot in an email" do
      sanitize_email("test.net").should == "test-dot-net"
    end
  end
end