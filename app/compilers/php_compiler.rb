class PhpCompiler < Compiler
  private

  def source_setup(container, code)
    container.store_file('main.php', code)
    true
  end

  def run(container)
    TestRunner.call(container, 'php main.php')
  end
end
