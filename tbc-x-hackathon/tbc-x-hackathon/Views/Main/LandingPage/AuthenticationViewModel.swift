//
//  AuthenticationViewModel.swift
//  tbc-x-hackathon
//
//  Created by Akaki Titberidze on 04.07.24.
//

import SwiftUI

final class AuthenticationViewModel: ObservableObject {
    @Published var showLandingPage: Bool = true
    @Published var showLoginPage: Bool = true
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var age: String = ""
    @Published var name: String = ""
    @Published var isUserAuthorized: Bool = false
    
    private let tokenKey = "some.keys.token"
    private let passwordKey = "some.keys.password"
    
    private let loginUrl = "/User/login"
    private let signupUrl = "/User/register"
    
    func login() {
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        NetworkService.shared.performRequest(urlPath: loginUrl, method: "POST", body: body) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["token"] as? String {
                        DispatchQueue.main.async {
                            KeychainService.shared.saveToKeychain(key: self.tokenKey, value: token)
                            self.isUserAuthorized = true
                        }
                    }
                } catch {
                    print("JSON parsing error:", error.localizedDescription)
                }
            } else {
                //handle cant register
            }
        }
    }

    func signup() {
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "age": Int(age) ?? 18,
            "userName": name
        ]
        
        NetworkService.shared.performRequest(urlPath: signupUrl, method: "POST", body: body) { data, response, error in
            guard let newData = data, error == nil else {
                print("Network error:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                self.login()
            } else {
                //handle cant login
            }
        }
    }
    
    func logout() {
        KeychainService.shared.deleteFromKeychain(key: tokenKey)
        DispatchQueue.main.async {
            self.isUserAuthorized = false
            self.email = ""
            self.password = ""
            self.age = ""
            self.name = ""
            self.showLoginPage = true
        }
    }
}