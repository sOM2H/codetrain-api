module TestRunner
  def self.call(container, params, extra_memory: 0, time_limit: 1, memory_limit: 16)
    memory_limit = extra_memory + memory_limit

    result = container.exec([
      'bash',
      '-c',
      "timeout #{time_limit}s /usr/bin/time -f '%e %M' -o resource_usage.txt #{params} > output.txt < input.txt"
    ]).last

    puts "Execution took #{time_limit} seconds"
    if result == 124
      raise Compiler::TimeLimitError, "Execution exceeded #{time_limit} seconds"
    end

    logs = container.read_file('resource_usage.txt')
    _, memory_used_kb = logs.split.map(&:to_f)
    memory_used_mb = memory_used_kb / 1024

    puts "Memory limit (used: #{memory_used_mb} MB, limit: #{memory_limit} MB)"
    if memory_used_mb > memory_limit
      raise Compiler::MemoryLimitError, "Memory limit exceeded (used: #{memory_used_mb} MB, limit: #{memory_limit} MB)"
    end

    return false unless result.zero?

    true
  end
end
