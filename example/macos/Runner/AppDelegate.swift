import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationWillResignActive(_ notification: Notification) {
    #if DEBUG
    // Prevent the app from pausing by not calling super in debug mode
    // super.applicationWillResignActive(notification)
    #else
    super.applicationWillResignActive(notification)
    #endif
  }
}
