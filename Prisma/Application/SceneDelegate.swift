//
//  SceneDelegate.swift
//  Prisma
//
//  Created by Gustavo Benitez Frehse on 01/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var savedShortCutItem: UIApplicationShortcutItem?

    func handleQuickAction(shortcutItem: UIApplicationShortcutItem) {
        let actionType = shortcutItem.type

        guard let navController = window?.rootViewController as? UINavigationController else {
            return
        }

        print("Handling quick action: \(actionType)")

        switch actionType {
            case "AddAesthetic":
                let createAestheticVC = CreateAestheticViewController()
                navController.present(createAestheticVC, animated: true)
            case "AddImage":
                let createImageVC = CreateImageViewController()
                navController.present(createImageVC, animated: true)
            default:
                break
        }
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let rootViewController: UIViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        if let shortcutItem = connectionOptions.shortcutItem {
            savedShortCutItem = shortcutItem
        }
    }

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        savedShortCutItem = shortcutItem
        completionHandler(true)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if let shortcutItem = savedShortCutItem {
            handleQuickAction(shortcutItem: shortcutItem)
            savedShortCutItem = nil
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}
