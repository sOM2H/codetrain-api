class RubyCompiler < Compiler
  private

  def source_setup(container, code)
    container.store_file('main.rb', code)
    true
  end

  def run(container)
    TestRunner.call(container, 'ruby main.rb')
  end
end
