class CppCompiler < Compiler
  private

  def source_setup(container, code)
    container.store_file('main.cpp', code)
    result = container.exec(['bash', '-c', 'g++ main.cpp -o application']).last
    return false unless result.zero?

    true
  end

  def run(container)
    TestRunner.call(container, './application')
  end
end
