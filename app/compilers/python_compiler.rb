class PythonCompiler < Compiler
  EXTRA_MEMORY = 9

  private

  def source_setup(container, code)
    container.store_file('main.py', code)
    true
  end

  def run(container)
    TestRunner.call(container, 'python3 main.py', extra_memory: EXTRA_MEMORY)
  end
end
