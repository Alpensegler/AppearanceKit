Pod::Spec.new do |spec|

  spec.name         = "AppearanceKit"
  spec.summary      = "More swifty way dark mode and theme supportment"
  spec.homepage     = "https://github.com/sundayfun/AppearanceKit"
  spec.version      = "0.0.1"
  spec.license      = "MIT"

  spec.ios.deployment_target = '10.0'
  spec.author = { "Frain" => "frainl@outlook.com" }
  spec.source = { :git => "" }
  spec.source_files  = "**/*.{h,m,swift}"
  spec.exclude_files = ['Tests', 'Package.swift']

end
