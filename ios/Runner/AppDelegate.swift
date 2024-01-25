import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
            GMSServices.provideAPIKey("AIzaSyCkW__vI2DazIWYjIMigyxwDtc_kyCBVIo")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
