class PhpCompiler < Compiler
  EXTRA_MEMORY = 17

  private

  def source_setup(container, code)
    container.store_file('main.php', code)
    true
  end

  def run(container)
    TestRunner.call(container, 'php main.php', extra_memory: EXTRA_MEMORY)
  end
end
