module TestRunner
  def self.call(container, params)
    result = container.exec(['bash', '-c', "#{params}  > output.txt < input.txt"]).last
    return false unless result.zero?

    true
  end
end
