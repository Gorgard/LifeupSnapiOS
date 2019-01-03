Pod::Spec.new do |s|

  s.name         = "LifeupSnap"
  s.version      = "0.1.4"
  s.summary      = "LifeupSnap iOS"
  s.homepage     = 'http://lifeuptest.life'
  s.license      = 'Lifeup co.,Ltd'
  s.author           = { 'Khwan Siricharoenporn' => 'card@lifeup.cool' }
  s.source       = { :git => 'https://github.com/Gorgard/LifeupSnapiOS.git',:tag => s.version.to_s}
  s.ios.deployment_target = '9.0'

  s.frameworks  = 'UIKit', 'AVFoundation'
  s.requires_arc = true
  s.static_framework = false
  s.default_subspec = 'All'

  s.subspec 'All' do |ss|
    ss.ios.dependency 'LifeupSnap/LifeupSnap'
  end

  s.subspec 'LifeupSnap' do |ss|
    ss.source_files  = 'LifeupSnap.framework'

  end

end