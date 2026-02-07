platform :ios, '15.0'

target 'BaseIOSApp' do
  use_frameworks!

  # Tools
  pod 'SwiftGen', '~> 6.6'
  pod 'SwiftLint', '~> 0.54'

  # Dependencies managed by SPM are defined in project.yml, 
  # but some might be moved here if needed. 
  # For now, we use Pods mainly for tools.
end

target 'BaseIOSAppTests' do
  inherit! :search_paths
end

target 'BaseIOSAppUITests' do
  inherit! :search_paths
end
