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

    def describe_actions *action_names, &block
      action_names.each do |action_name|
        describe_action action_name, &block
      end
    end

    def the_assigned assign_name, *attrs, &block
      describe "the assigned #{assign_name} #{attrs.join(' ')}" do
        subject { attrs.inject(assigns(assign_name)) {|result, attr| result.send(attr) } }

        it &block
      end
    end
  end
end
