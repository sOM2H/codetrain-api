module TestSeter
  def self.call(container, test)
    container.store_file('input.txt', test.input)
  end
end
