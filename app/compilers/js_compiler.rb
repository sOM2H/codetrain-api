class JsCompiler < Compiler
  EXTRA_MEMORY = 28

  private

  def source_setup(container, code)
    container.store_file('main.js', code)
    true
  end

  def run(container)
    TestRunner.call(container, 'node main.js', extra_memory: EXTRA_MEMORY)
  end
end
