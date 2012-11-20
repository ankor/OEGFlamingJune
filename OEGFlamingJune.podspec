#
# Be sure to run `pod spec lint OEGFlamingJune.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "OEGFlamingJune"
  s.version      = "0.0.1"
  s.summary      = "Models for REST web services using AFNetworking."
  s.homepage     = "https://github.com/ankor/OEGFlamingJune"

  # Specify the license type. CocoaPods detects automatically the license file if it is named
  # `LICENSE*.*', however if the name is different, specify it.
  s.license      = 'MIT (example)'
  # s.license      = { :type => 'MIT (example)', :file => 'FILE_LICENSE' }
  #
  # Only if no dedicated file is available include the full text of the license.
  #
  # s.license      = {
  #   :type => 'MIT (example)',
  #   :text => <<-LICENSE
  #             Copyright (C) <year> <copyright holders>

  #             All rights reserved.

  #             Redistribution and use in source and binary forms, with or without
  #             ...
  #   LICENSE
  # }

  s.author       = { "Anders Carlsson" => "andersc@gmail.com" }

  #s.source       = { :git => "https://github.com/ankor/OEGFlamingJune.git", :tag => "0.0.1" }
  s.source       = { :git => "https://github.com/ankor/OEGFlamingJune.git", :commit => "HEAD" }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source_files = 'OEGFlamingJune'

  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 1.0'
end
