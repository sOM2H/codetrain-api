module Containers
  class Create
    include Callable

    def call
      container = Docker::Container.create('Cmd' => ['tail', '-f', '/dev/null'],
                                           'Image' => 'compiler_system')
      container.start
      container
    end
  end
end
