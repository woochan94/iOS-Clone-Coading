//
//  LaunchController.swift
//  InstagramClone
//
//  Created by 정우찬 on 2024/03/29.
//

import Alamofire
import UIKit

struct LoginStatusResponse: Decodable {
    let isLoggedIn: Bool
    let uid: String
}

class LaunchController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        checkUserIsLoggedIn()
    }
    
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
                    if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        scene.showLoginController()
                    }
                    return
                }
                
                if isLoggedIn {
                    if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        scene.showMainTabController()
                    }
                } else {
                    if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        scene.showLoginController()
                    }
                }
            }
        } else {
            print("DEBUG: idToken 없음")
            if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                scene.showLoginController()
            }
        }
    }
}
