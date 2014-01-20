Pod::Spec.new do |s|
  s.name     = 'PCDefaults'
  s.version  = '0.0.9'
  s.platform = :ios
  s.license  = { :type => 'Custom', :text => 'Copyright (c) 2013 Papercloud. All rights reserved.' }
  s.summary  = 'Helpers to quickly create patterns we use often.'
  s.homepage = 'http://papercloud.com.au/'
  s.authors  = { 'Tom Spacek' => 'ts@papercloud.com.au' }
  s.source   = { :git => 'https://github.com/Papercloud/PCDefaults.git',
           :tag => s.version.to_s }
  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.dependency 'RestKit'
  s.dependency 'Inflections'
  s.dependency 'MagicalRecord'
  s.frameworks = 'CoreData', 'CoreLocation'
  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files = 'PCDefaults/Core/*{h,m}'
  end

  s.subspec 'Map' do |ss|
    ss.source_files = 'PCDefaults/Map/*{h,m}'
    ss.dependency     'Google-Maps-iOS-SDK'
  end

  s.subspec 'Auth' do |ss|
    ss.source_files = 'PCDefaults/Authentication/**/*{h,m}'
    ss.resource_bundles = { 'PCDAuth' => ['PCDefaults/Authentication/PCDAuth.storyboard'] }
  end
end
