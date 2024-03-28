//
//  SceneDelegate.swift
//  InstagramClone
//
//  Created by 정우찬 on 2024/03/12.
//

import Alamofire
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        checkUserIsLoggedIn()
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

struct LoginStatusResponse: Decodable {
    let isLoggedIn: Bool
    let uid: String
}

extension SceneDelegate {
    // MARK: - API

    func checkLoginStatus(_ idToken: String, completion: @escaping (Bool, String?, Error?) -> Void) {
        let parameter: Parameters = [
            "idToken": idToken
        ]
        
        AF.request("http://localhost:3000/users/checkLoginStatus", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseDecodable(of: LoginStatusResponse.self) { response in
            switch response.result {
            case let .success(loginStatus):
                completion(loginStatus.isLoggedIn, loginStatus.uid, nil)
            case let .failure(error):
                completion(false, nil, error)
            }
        }
    }
    
    // MARK: - Helper

    func checkUserIsLoggedIn() {
        if let idToken = UserDefaults.standard.string(forKey: "idToken"), idToken.isEmpty == false {
            print("DEBUG: idToken 존재")
            checkLoginStatus(idToken) { isLoggedIn, _, error in
                if let error = error {
                    print("DEBUG: Error checking login status: \(error.localizedDescription)")
                    self.showLoginController()
                    return
                }

                if isLoggedIn {
                    self.showMainTabController()
                } else {
                    self.showLoginController()
                }
            }
        } else {
            print("DEBUG: idToken 없음")
            showLoginController()
        }
    }
    
    func showMainTabController() {
        window?.rootViewController = MainTabController()
    }
    
    func showLoginController() {
        UserDefaults.standard.removeObject(forKey: "idToken")
        window?.rootViewController = UINavigationController(rootViewController: LoginController())
    }
}
