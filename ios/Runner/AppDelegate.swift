import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    DispatchQueue.main.async {
      self.blockScreenCapture()
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Prevents screenshots and screen recordings on iOS by embedding a
  /// secure UITextField whose layer hosts the root window layer. iOS
  /// automatically blurs/blocks content in layers attached to secure fields.
  private func blockScreenCapture() {
    guard let window = self.window else { return }
    let field = UITextField()
    field.isSecureTextEntry = true
    field.translatesAutoresizingMaskIntoConstraints = false
    window.addSubview(field)
    NSLayoutConstraint.activate([
      field.centerXAnchor.constraint(equalTo: window.centerXAnchor),
      field.centerYAnchor.constraint(equalTo: window.centerYAnchor),
      field.widthAnchor.constraint(equalToConstant: 1),
      field.heightAnchor.constraint(equalToConstant: 1),
    ])
    // Reparent the window layer under the secure field layer so the OS
    // screenshot protection covers the entire window.
    if let secureLayer = field.layer.sublayers?.first {
      secureLayer.addSublayer(window.layer)
    }
  }
}
