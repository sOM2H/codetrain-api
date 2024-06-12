class PythonCompiler < Compiler
  private

  def source_setup(container, code)
    container.store_file('main.py', code)
    true
  end

  def run(container)
    TestRunner.call(container, 'python3 main.py')
  end
end
