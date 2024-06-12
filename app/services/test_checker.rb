module TestChecker
  def self.call(container, test)
    answer = test.output
    output = container.read_file('/output.txt')
    answer.chop! while answer[-1] == "\n"
    output.chop! while output[-1] == "\n"

    answer == output
  end
end
