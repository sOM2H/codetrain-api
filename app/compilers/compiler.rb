class Compiler
  class CompilerError < StandardError
    attr_reader :index
    def initialize(index)
      @index = index
    end
  end
  class CompilationError < StandardError; end
  class RunTimeError < CompilerError; end
  class WrongAnswer < CompilerError; end

  def initialize(container, attempt)
    @container = container
    @attempt = attempt
  end

  def call
    raise CompilationError unless source_setup @container, @attempt.code

    tests.each_with_index do |test, index|
      @attempt.update!(log: (index + 1).to_s)
      @attempt.broadcast_attempt

      TestSeter.call(@container, test)
      raise RunTimeError, index unless run @container
      raise WrongAnswer, index unless TestChecker.call(@container, test)
    end
    @attempt
  end

  private

  def tests
    Test.where(problem_id: @attempt.problem_id)
  end
end
