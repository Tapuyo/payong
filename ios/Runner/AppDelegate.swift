import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //AIzaSyCSrn2Mh8tdIUp-3cnlgZYmr6KdEaofm5I
    GMSServices.provideAPIKey("AIzaSyDIke2B88yPrcXkYRIO8_qsZQZqchbEtvw")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
