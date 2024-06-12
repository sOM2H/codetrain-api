module Tests
  class Create
    include Callable

    def initialize(params:)
      @params = params
    end

    def call
      create_test
    end

    private

    attr_reader :params

    def create_test
      Test.create(params)
    end
  end
end
