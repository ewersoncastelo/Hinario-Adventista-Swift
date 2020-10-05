//
//  SignInWithAppleManager.swift
//  TestingUIKitSignInWithApple
//
//  Created by Alex Nagy on 04/11/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation
import AuthenticationServices

@available(iOS 13.0, *)
struct SignInWithAppleManager {
    
    static let userIdentifierKey = "userIdentifier"
    
    static func checkUserAuth(completion: @escaping (AuthState) -> ()) {
        guard let userIdentifier = UserDefaults.standard.string(forKey: userIdentifierKey) else {
            print("User identifier does not exist")
            completion(.undefined)
            return
        }
        if userIdentifier == "" {
            print("User identifier is empty string")
            completion(.undefined)
            return
        }
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid. Show Home UI Here
                    print("Credential state: .authorized")
                    completion(.signedIn)
                    break
                case .revoked:
                    // The Apple ID credential is revoked. Show SignIn UI Here.
                    print("Credential state: .revoked")
                    completion(.undefined)
                    break
                case .notFound:
                    // No credential was found. Show SignIn UI Here.
                    print("Credential state: .notFound")
                    completion(.signedOut)
                    break
                default:
                    break
                }
            }
        }
    }
    
}
