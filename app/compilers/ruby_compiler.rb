class RubyCompiler < Compiler
  EXTRA_MEMORY = 9

  private

  def source_setup(container, code)
    container.store_file('main.rb', code)
    true
  end

  def run(container)
    TestRunner.call(container, 'ruby main.rb', extra_memory: EXTRA_MEMORY)
  end
end
