task :create_images do
  image = Docker::Image.build_from_dir('./docker/compilers/.')
  image.tag('repo' => 'compiler_system', 'tag' => 'latest', force: true)
end
