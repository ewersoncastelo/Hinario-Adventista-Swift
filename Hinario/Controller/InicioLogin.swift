//
//  InicioLogin.swift
//  Hinário
//
//  Created by Ewerson Castelo on 02/01/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import SVProgressHUD
import LocalAuthentication
import AuthenticationServices
import CryptoKit

protocol InicioLoginControllerDelegate {
	func didFinishAuth()
}

class InicioLogin: UIViewController {
	
	var delegate: InicioLoginControllerDelegate?
	
	let logoImageBackground: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "login-layout"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.alpha = 0.6
		return imageView
	}()
	
	//Add an view for half of screen, when it rotation and logo don't distorce
	let topImageConteinerView: UIView = {
		let imageTopView = UIView()
		imageTopView.translatesAutoresizingMaskIntoConstraints = false
		return imageTopView
	}()
	
	let logoImage: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "logo-app"))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	//Button LoginFace e LoginGoogle e LoginAnonimo - Make sure you apply the correct encapsulation principles in your classes
	private let faceButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Login com Facebook", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor( .white, for: .normal)
		button.backgroundColor = .blueFace
		button.alpha = 0.9
		button.layer.cornerRadius = 7
		button.layer.masksToBounds = true
		//Add target to touch buttom
		button.addTarget(self, action: #selector(handleFace), for: .touchUpInside)
		return button
	}()
	
	private let anonymosButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Continuar sem login", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor( .white, for: .normal)
		button.alpha = 0.9
		button.layer.cornerRadius = 7
		button.layer.masksToBounds = true
		button.backgroundColor = UIColor(red: 190/255, green: 194/255, blue: 201/255, alpha: 1)
		button.addTarget(self, action: #selector(handleAnonymos), for: .touchUpInside)
		return button
	}()
	
	private let touchFaceButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Acesso Digital", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor( .white, for: .normal)
		button.alpha = 0.9
		//set radius corner button
		button.layer.cornerRadius = 7
		button.layer.masksToBounds = true
		button.backgroundColor = UIColor(red: 100/255, green: 177/255, blue: 145/255, alpha: 1)
		button.addTarget(self, action: #selector(handleTouch), for: .touchUpInside)
		return button
	}()
	
	@available(iOS 13.0, *)
	lazy var appleButton : ASAuthorizationAppleIDButton = {
		let button = ASAuthorizationAppleIDButton()
		button.addTarget(self, action: #selector(handleApple), for: .touchUpInside)
		return button
	}()
	
		
	@available(iOS 13.0, *)
	@objc fileprivate func handleApple(){
		print("tapped apple")
		let request = ASAuthorizationAppleIDProvider().createRequest()
		request.requestedScopes = [.fullName, .email]
		let controller = ASAuthorizationController(authorizationRequests: [request])
		controller.delegate = self
		controller.presentationContextProvider = self
		controller.performRequests()
		
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Define Layout Contraints
		setupLayout()
		
		//Define Layout Bottom Controls
		setupBottomControls()
		
		SVProgressHUD.dismiss()
	}
	
	@objc func handleFace() {
		
		let fbLoginManager = LoginManager()
		fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
			if let error = error {
				print("Failed to login: \(error.localizedDescription)")
				return
			}
			
			guard let accessToken = AccessToken.current else {
				print("Failed to get access token")
				return
			}
			
			let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
			
			// Perform login by calling Firebase APIs
			Auth.auth().signIn(with: credential, completion: { (user, error) in
				if let error = error {
					print("Login error: \(error.localizedDescription)")
					let alertController = UIAlertController(title: "Atenção", message: error.localizedDescription, preferredStyle: .alert)
					let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
					alertController.addAction(okayAction)
					self.present(alertController, animated: true, completion: nil)
					
					return
				}
				print("Logado pelo Facebook no Firebase")
				self.userLogado()
			})
		}
	}
	
	
	@objc fileprivate func handleTouch(){
		let context = LAContext()
		
		if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil){
			context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Isso permite que você se conecte com segurança no aplicativo") { (sucess, error) in
				
				if sucess {
					Auth.auth().signInAnonymously() { (user, error) in
						print("Conectado Anônimamente")
						self.userLogado()
					}
				} else {
					AlertExt.showBasic(title: "Ops.. Houve algum erro", msg: "Tente Novamente ou verifique se seu dispositivo suporta este tipo de acesso", vc: self)
				}
			}
		} else {
			AlertExt.showBasic(title: "Não autorizado", msg: "Autenticação de segurança não permitida", vc: self)
		}

	}
	
	@objc func handleAnonymos() {
		Auth.auth().signInAnonymously() { (user, error) in
			if let error = error {
				print("Login error: \(error.localizedDescription)")
				let alertController = UIAlertController(title: "Atenção! Houve Algum Erro!", message: error.localizedDescription, preferredStyle: .alert)
				let okayAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
				alertController.addAction(okayAction)
				self.present(alertController, animated: true, completion: nil)
				
				return
			}
			print("Conectado Anônimamente")
			self.userLogado()
		}
	}
	
	func userLogado() {
		//Present the main view
		let hinosController = HinosController()
		let navController = CustomNavigationController(rootViewController: hinosController)
        navController.modalPresentationStyle = .fullScreen
		self.present(navController, animated: true, completion: nil)
	}
	
	private func setupLayout() {
		
		//Adiciona Imagem de Fundo
		view.addSubview(logoImageBackground)
		logoImageBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		logoImageBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		logoImageBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		logoImageBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	
		//Adiciona View Para adicionar o Logo
		view.addSubview(topImageConteinerView)
		topImageConteinerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		topImageConteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		topImageConteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		topImageConteinerView.addSubview(logoImage)
	
		//Auto Layout Mode for LOGO
		logoImage.centerXAnchor.constraint(equalTo: topImageConteinerView.centerXAnchor).isActive = true
		logoImage.centerYAnchor.constraint(equalTo: topImageConteinerView.centerYAnchor).isActive = true
		logoImage.heightAnchor.constraint(equalTo: topImageConteinerView.heightAnchor, multiplier: 0.6).isActive = true
		topImageConteinerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
	}
	
	fileprivate func setupBottomControls() {
		if #available(iOS 13.0, *){
			let bottomControlsStackView = UIStackView(arrangedSubviews: [faceButton, appleButton, anonymosButton])
			bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
			bottomControlsStackView.distribution = .equalSpacing
			bottomControlsStackView.alignment = .fill
			bottomControlsStackView.axis = .vertical
			bottomControlsStackView.spacing = 2
			view.addSubview(bottomControlsStackView)
			
			NSLayoutConstraint.activate([
			bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
			bottomControlsStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			bottomControlsStackView.heightAnchor.constraint(equalToConstant: 90),
			bottomControlsStackView.widthAnchor.constraint(equalToConstant: 194),
			])
		} else {
			let bottomControlsStackView = UIStackView(arrangedSubviews: [faceButton, touchFaceButton, anonymosButton])
			bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
			bottomControlsStackView.distribution = .equalSpacing
			bottomControlsStackView.alignment = .fill
			bottomControlsStackView.axis = .vertical
			bottomControlsStackView.spacing = 2
			view.addSubview(bottomControlsStackView)
		
			NSLayoutConstraint.activate([
				bottomControlsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
				bottomControlsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				bottomControlsStackView.heightAnchor.constraint(equalToConstant: 60),
				bottomControlsStackView.widthAnchor.constraint(equalToConstant: 194)
			])
			
		}
		
		
	}
}

extension InicioLogin: ASAuthorizationControllerDelegate {
	
	@available(iOS 13.0, *)
	private func registerNewAccount(credential: ASAuthorizationAppleIDCredential){
		print("Register account with: \(credential.user)")
		self.userLogado()
		delegate?.didFinishAuth()
		self.dismiss(animated: true, completion: nil)
	}
	
	@available(iOS 13.0, *)
	private func SignInWithExistingAccount(credential: ASAuthorizationAppleIDCredential){
		print("Signing in existing account with: \(credential.user)")
		self.userLogado()
		delegate?.didFinishAuth()
		self.dismiss(animated: true, completion: nil)
	}
	
	@available(iOS 13.0, *)
	private func SignInWithUserAndPassword(credential: ASPasswordCredential){
		print("Signing account with keyChain credential: \(credential.user)")
		self.userLogado()
		delegate?.didFinishAuth()
		self.dismiss(animated: true, completion: nil)
	}
	
	@available(iOS 13.0, *)
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		//
		switch authorization.credential {
		case let appleIdCredential as ASAuthorizationAppleIDCredential:
			let userId = appleIdCredential.user
			UserDefaults.standard.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
			
			if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
				registerNewAccount(credential: appleIdCredential)
				self.userLogado()
			} else {
				SignInWithExistingAccount(credential: appleIdCredential)
				self.userLogado()
			}
			
			break
		
		case let passwordCredential as ASPasswordCredential:
			let userId = passwordCredential.user
			UserDefaults.standard.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
			self.userLogado()
			SignInWithUserAndPassword(credential: passwordCredential)
		default:
			break
		}
	}
	
	@available(iOS 13.0, *)
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
		let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alertController.addAction(actionOk)
		self.present(alertController, animated: true, completion: nil)
	}
}

extension InicioLogin: ASAuthorizationControllerPresentationContextProviding{
	@available(iOS 13.0, *)
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		print("ok true")
		self.userLogado()
		return self.view.window!
	}
	
}
