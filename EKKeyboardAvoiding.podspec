Pod::Spec.new do |s|
  s.name         = "EKKeyboardAvoiding"
  s.version      = "2.0.1tc"
  s.summary      = "It's an universal solution that automatically changes content inset of your UIScrollView classes."
  s.homepage     = "https://github.com/TippingCanoe/EKKeyboardAvoiding.git"
  s.license      = 'MIT'
  s.author       = { "Evgeniy Kirpichenko" => "evkirpichenko@gmail.com" }
  s.source       = { :git => "https://github.com/TippingCanoe/EKKeyboardAvoiding.git", :tag => "2.0.4tc" }
  s.platform     = :ios, '5.0'
  s.source_files = 'EKKeyboardAvoiding/*.{h,m}'
  s.requires_arc = true
end
