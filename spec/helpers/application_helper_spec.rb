require 'spec_helper'

describe ApplicationHelper do
  describe "#boolean_to_check" do
    context "when true param" do
      subject { boolean_to_check(true) }

      it { should == "&#10003;".html_safe }
    end

    context "when false param" do
      subject { boolean_to_check(false) }

      it { should == "&mdash;".html_safe }
    end
  end
end
