Pod::Spec.new do |s|
  s.name     = 'Generated'
  s.version  = '0.0.0'
  s.platform = :ios
  s.summary  = 'Generated content. Should only ever be a local pod.'
  s.requires_arc = true
  s.source_files = 'Generated/**/*{h,m}'
  s.ios.deployment_target = '6.0'
end
