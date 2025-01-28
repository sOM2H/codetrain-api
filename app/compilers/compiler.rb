class Compiler
  EXTRA_MEMORY = 0

  class CompilerError < StandardError
    attr_reader :index
    def initialize(index)
      @index = index
    end
  end
  class CompilationError < StandardError; end
  class RunTimeError < CompilerError; end
  class WrongAnswer < CompilerError; end
  class TimeLimitError < CompilerError; end
  class MemoryLimitError < CompilerError; end

  def initialize(container, attempt)
    @container = container
    @attempt = attempt
  end

  def call
    raise CompilationError unless source_setup @container, @attempt.code

    tests.each_with_index do |test, index|
      update_score(index)
      @attempt.update!(log: (index + 1).to_s)
      @attempt.broadcast_attempt

      TestSeter.call(@container, test)
      begin
        raise RunTimeError, index unless run @container
      rescue Compiler::TimeLimitError
        raise TimeLimitError, index
      rescue Compiler::MemoryLimitError
        raise MemoryLimitError, index
      end
      raise WrongAnswer, index unless TestChecker.call(@container, test)
    end
    @attempt
  end

  private

  def update_score(index)
    total_tests = tests.count
    score = ((index).to_f / total_tests * 100).round(2)
    @attempt.update(score: score)
  end

  def tests
    Test.where(problem_id: @attempt.problem_id)
  end
end
