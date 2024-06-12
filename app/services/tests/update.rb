module Tests
  class Update
    include Callable

    def initialize(test:, params:)
      @test = test
      @params = params
    end

    def call
      update_test
    end

    private

    attr_reader :test, :params

    def update_test
      test.update(params)
      test
    end
  end
end
