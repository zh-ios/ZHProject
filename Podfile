

#https://guides.cocoapods.org/syntax/podfile.html#platform

#Specifies the platform for which a static library should be built
platform :ios, '9.0'

#This group list the options to configure workspace and to set global settings
#If no explicit Xcode workspace is specified and only one project exists in the same directory as the Podfile, then the name of that project is used as the workspace’s name.
workspace 'ZHProject'

def mainProjectPod
    pod 'MJRefresh', '~> 3.1.15'
end

target 'ZHProject' do

  mainProjectPod
  pod 'AFNetworking', '~> 3.2.1'
  
  project 'ZHProject.xocdeproj'
end

target 'CommonFunction' do
#    Specifies the Xcode project that contains the target that the Pods library should be linked with.
    project 'CommonFunction/CommonFunction.xcodeproj'
end
