paths = %w[config/**/*.rb app/**/*.rb].freeze

paths.each do |path|
  Dir[File.join(CSDApp.root, path)].sort.each do |file|
    next if file.include?('initializers/autoloader')

    require file
  end
end
