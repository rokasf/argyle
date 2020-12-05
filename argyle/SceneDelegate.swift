//
//  SceneDelegate.swift
//  argyle
//
//  Created by Rokas Firantas on 2020-12-05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let viewModel = SearchViewModel(APIService())
        let vc = SearchViewController(viewModel)
        let nvc = UINavigationController(rootViewController: vc)

        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
    }
}

