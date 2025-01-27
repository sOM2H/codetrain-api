module Containers
  class Create
    include Callable

    def call
      memory_limit_bytes = 128 * 1024 * 1024

      args = {
        'Cmd' => ['tail', '-f', '/dev/null'],
        'Image' => 'compiler_system',
        'HostConfig' => {
          'Memory' => memory_limit_bytes,
          'MemorySwap' => memory_limit_bytes
        }
      }

      container = Docker::Container.create(**args)
      container.start
      container
    end
  end
end
