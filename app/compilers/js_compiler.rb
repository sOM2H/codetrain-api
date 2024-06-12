class JsCompiler < Compiler
  private

  def source_setup(container, code)
    container.store_file('main.js', code)
    true
  end

  def run(container)
    TestRunner.call(container, 'node main.js')
  end
end
