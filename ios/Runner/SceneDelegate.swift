import Flutter
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }

    window = UIWindow(windowScene: windowScene)

    let flutterEngine = FlutterEngine(name: "SceneDelegateEngine")
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)

    let controller = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {}

  func sceneDidBecomeActive(_ scene: UIScene) {}

  func sceneWillResignActive(_ scene: UIScene) {}

  func sceneWillEnterForeground(_ scene: UIScene) {}

  func sceneDidEnterBackground(_ scene: UIScene) {}
}
