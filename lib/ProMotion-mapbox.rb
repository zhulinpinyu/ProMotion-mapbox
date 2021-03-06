# encoding: utf-8
unless defined?(Motion::Project::Config)
  raise "ProMotion-mapbox must be required within a RubyMotion project."
end

require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  lib_dir_path = File.dirname(File.expand_path(__FILE__))
  app.files << File.join(lib_dir_path, "ProMotion/map/map_screen_annotation.rb")
  app.files << File.join(lib_dir_path, "ProMotion/map/map_screen_module.rb")
  app.files << File.join(lib_dir_path, "ProMotion/map/map_screen.rb")

  app.frameworks += %w(CoreLocation)

  app.pods do
    pod "Mapbox-iOS-SDK"
  end

end
