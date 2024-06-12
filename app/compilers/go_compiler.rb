class GoCompiler < Compiler
  private

  def source_setup(container, code)
    container.store_file('main.go', code)
    result = container.exec(['bash', '-c', 'go build main.go']).last
    return false unless result.zero?

    true
  end

  def run(container)
    TestRunner.call(container, './main')
  end
end
