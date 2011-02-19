module RSpecMacros
  def self.included base
    base.extend Macros
  end

  module Macros
    def the name, *attrs, &block
      describe "the #{name}" do
        subject { attrs.inject(self.send(name)) {|result, attr| result.send(attr) } }

        it &block
      end
    end
  end
end
