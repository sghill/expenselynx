RSpec::Matchers.define :assign do |name|
  chain(:with) {|value| @with = value }

  match do |controller|
    mixed_controller(controller).assigns(name.to_s) == @with
  end

  failure_message_for_should do |controller|
    "expected '#{name}' to be assigned with '#{@with.inspect}', but was #{mixed_controller(controller).assigns(name.to_s).inspect}"
  end

  failure_message_for_should_not do
    "expected '#{name}' not to be assigned with '#{@with.inspect}', but was"
  end

  description do
    "should assign #{name} with #{@with.inspect}"
  end

  def mixed_controller controller
    clazz = Class.new do
      include ActionDispatch::TestProcess

      def initialize controller
        @controller = controller
      end
    end
    clazz.new(controller)
  end
end

