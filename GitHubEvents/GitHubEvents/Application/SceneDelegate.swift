//
//  SceneDelegate.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 3.11.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let window = UIWindow(windowScene: scene)
        let viewController = EventListViewController()
        viewController.context = appDelegate.persistentContainer.viewContext
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

}

