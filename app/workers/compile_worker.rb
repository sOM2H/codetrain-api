class CompileWorker
  include Sidekiq::Worker

  def perform(attempt_id)
    @attempt = Attempt.find(attempt_id.to_i)
    container = Containers::Create.call

    (eval @attempt.language.compiler.to_s).new(container, @attempt).call
    @attempt.passed!
  rescue Compiler::CompilationError
    compilation_error
  rescue Compiler::RunTimeError => e
    runtime_error(e.index)
  rescue Compiler::WrongAnswer => e
    wrong_answer(e.index)
  rescue Docker::Error::TimeoutError
    time_limit_error
  ensure
    container&.delete(force: true)
    @attempt
  end

  private

  def update_logs(index)
    #@attempt.update!(logs: (index + 1).to_s)
  end

  def wrong_answer(index)
    @attempt.wrong_answer!
  end

  def runtime_error(index)
    @attempt.runtime_error!
  end

  def time_limit_error
    @attempt.time_limit!
  end

  def compilation_error
    @attempt.compilation_error!
  end
end
