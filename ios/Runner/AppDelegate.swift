import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_application:UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken:Data){


    Messaging.messaging().appsToken=deviceToken
    print("Token:\(deviceToken)")
    super.application(application,didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)
    
  }
}
