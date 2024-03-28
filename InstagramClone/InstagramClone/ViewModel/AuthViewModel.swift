//
//  AuthViewModel.swift
//  InstagramClone
//
//  Created by 정우찬 on 2024/03/24.
//

import Alamofire
import UIKit

protocol AuthViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}

struct LoginViewModel: AuthViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct RegistrationViewModel: AuthViewModel {
    var email: String?
    var password: String?
    var fullName: String?
    var userName: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullName?.isEmpty == false && userName?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (UploadResponse?, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "\(NSUUID().uuidString)", mimeType: "image/jpeg")
        }, to: "http://localhost:3000/users/upload").responseDecodable(of: UploadResponse.self) { response in
            switch response.result {
            case let .success(uploadResponse):
                completion(uploadResponse, nil)
            case let .failure(error):
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (RegisterResponse?, Error?) -> Void) {
        uploadImage(credentials.profileImage) { response, error in
            guard let url = response?.url, error == nil else {
                completion(nil, error)
                return
            }
            
            let parameters: Parameters = [
                "email": credentials.email,
                "password": credentials.password,
                "fullName": credentials.fullName,
                "userName": credentials.userName,
                "profileImageUrl": url
            ]
            
            AF.request("http://localhost:3000/users/register", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case let .success(registerResponse):
                    completion(registerResponse, nil)
                case let .failure(error):
                    completion(nil, error)
                }
            }
        }
    }
}
