module Tests
  class Destroy
    include Callable

    def initialize(test:)
      @test = test
    end

    def call
      destroy_test
    end

    private

    attr_reader :test

    def destroy_test
      test.destroy
    end
  end
end
