class JavaCompiler < Compiler
  EXTRA_MEMORY = 30

  private

  def source_setup(container, code)
    container.store_file('Main.java', code)
    result = container.exec(['bash', '-c', 'javac Main.java']).last
    return false unless result.zero?

    true
  end

  def run(container)
    TestRunner.call(container, 'java Main', extra_memory: EXTRA_MEMORY)
  end
end
