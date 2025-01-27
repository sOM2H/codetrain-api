class CppCompiler < Compiler
  EXTRA_MEMORY = 4

  private

  def source_setup(container, code)
    container.store_file('main.cpp', code)
    result = container.exec(['bash', '-c', 'g++ main.cpp -o application']).last
    return false unless result.zero?

    true
  end

  def run(container)
    TestRunner.call(container, './application', extra_memory: EXTRA_MEMORY)
  end
end
