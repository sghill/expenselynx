module ControllerMacros
  def self.included base
    base.extend Macros
  end

  module Macros
    def describe_action action_name, &block
      describe "##{action_name}" do
        before :each do
          get action_name
        end

        instance_eval &block
      end
    end

    def assign assign_name, *attrs, &block
      describe "the assign #{assign_name}" do
        subject { attrs.inject(assigns(assign_name)) {|result, attr| result.send(attr) } }

        it &block
      end
    end
  end
end
