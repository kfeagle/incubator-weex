Pod::Spec.new do |s|


  s.name         = "GCanvas4Weex"
  s.version      = "1.0.0"
  s.summary      = "GCanvas Weex Plugin For iOS Core SDK For iOS."

  s.description  = <<-DESC
                   GCanvas Weex Plugin For iOS Core SDK For iOS
                   DESC

  s.homepage     = "http://gitlab.alibaba-inc.com/app-engine/G-Canvas"
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
            Alibaba-INC copyright
    LICENSE
  }

  s.author       = { '韦青' => 'weixing.jwx@alibaba-inc.com' }
  
  s.platform     = :ios
  s.ios.deployment_target = '7.0'


  s.dependency 'GCanvas'
  s.dependency 'SDWebImage'
  
  s.source = { :path => '.' }
  s.source_files = 'GCanvas4Weex/**/*.{h,m,mm}'
  s.frameworks = 'Foundation','UIKit','GLKit'

end
