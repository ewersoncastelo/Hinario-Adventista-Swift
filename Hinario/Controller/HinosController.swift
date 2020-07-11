//
//  ViewController.swift
//  Hinario
//
//  Created by Ewerson Castelo on 06/12/2017.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//
import UIKit
import Firebase
import Reachability
import GoogleMobileAds
import SVProgressHUD

var currentValueFont = UserDefaults.standard.string(forKey: "fontSelected")
var currentColorBack = UserDefaults.standard.string(forKey: "colorBackSelected")

class NetworkActivityIndicatorManager: NSObject {
	private static var loadingCount = 0
	
	class func NetworkOperationStarted(){
		if loadingCount == 0 {
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
		}
		loadingCount += 1
	}
	
	class func networkOperationFinished(){
		if loadingCount > 0 {
			loadingCount -= 1
		}
		
		if loadingCount == 0 {
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
}

class HinosController: UITableViewController {
	let cellId = "cellId"

	var favoritableHinos = [Hinario]()
	var favoritosBook:BookmarkController?
	
	var filteredCandies = [Hinario]()
	let reachability = try? Reachability()
	let searchController = UISearchController(searchResultsController: nil)
	
	// MARK: - Etablish Connection Firebase
	let storage = Storage.storage().reference()
	let ref = Database.database().reference(withPath: "hinos")
	
	//Banner Admob
	var interstitial:GADInterstitial?
	var bannerView: GADBannerView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.register(HinosCell.self, forCellReuseIdentifier: cellId)

		navigationItem.title = "Hinário Seven Day"
		
		view.backgroundColor = .white
		tableView.backgroundColor = .lightGray
		tableView.tableFooterView = UIView() //let blank UIview footer
		//Ativando o Self Sizing Class
		tableView.estimatedRowHeight = 70
		tableView.rowHeight = UITableView.automaticDimension
		tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
		tableView.separatorColor = UIColor.verdeTitulo
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sair", style: .plain, target: self, action: #selector(handleLogout))
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Favoritos", style: .plain, target: self, action: #selector(handleBookmark))
		
//		navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Sair", style: .plain, target: self
//			, action: #selector(handleLogout)), UIBarButtonItem(title: "Remover", style: .plain, target: self
//				, action: #selector(handleADSremove))]
		
		//UIsearchBar
		searchBarImplementing()
		
		//Logo Icon NavigationBar
		logoNavigationBar()
		
		//Tipo de Fonte Padrão
		fontDefault()
		
		//Cor do Fundo PadrÃo
		backColor()
		
//		//Checa se o usuario está logado
		checkUserIsLogin()
		
		//Obtem dados database
		fetchListHinos()
		
		//Banner
		fetchBannerADS()
		
		// Instantiate the banner view with your desired banner size.
		bannerView = GADBannerView(adSize: kGADAdSizeBanner)
		addBannerViewToView(bannerView)
		bannerView.rootViewController = self
		bannerView.adUnitID = "ca-app-pub-1249842998763621/9331041913"
		bannerView.load(GADRequest())
		
		//Remove the of ViewDidAppear
		NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
		do{
			try reachability?.startNotifier()
		}catch{
			print("could not start reachability notifier")
		}

	}

	func addBannerViewToView(_ bannerView: GADBannerView) {
		bannerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(bannerView)
		if #available(iOS 11.0, *) {
			positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
		}
		else {
			positionBannerViewFullWidthAtBottomOfView(bannerView)
		}
	}
	
	// MARK: - view positioning
	@available (iOS 11, *)
	func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
		// Position the banner. Stick it to the bottom of the Safe Area.
		// Make it constrained to the edges of the safe area.
		let guide = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
			guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
			guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
			])
	}
	
	func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
		view.addConstraint(NSLayoutConstraint(item: bannerView,
											  attribute: .leading,
											  relatedBy: .equal,
											  toItem: view,
											  attribute: .leading,
											  multiplier: 1,
											  constant: 0))
		view.addConstraint(NSLayoutConstraint(item: bannerView,
											  attribute: .trailing,
											  relatedBy: .equal,
											  toItem: view,
											  attribute: .trailing,
											  multiplier: 1,
											  constant: 0))
		view.addConstraint(NSLayoutConstraint(item: bannerView,
											  attribute: .bottom,
											  relatedBy: .equal,
											  toItem: bottomLayoutGuide,
											  attribute: .top,
											  multiplier: 1,
											  constant: 0))
	}

	private func fetchBannerADS() {
		//First Banner
		interstitial = GADInterstitial(adUnitID: "ca-app-pub-1249842998763621/1161129630")
		let request = GADRequest()
		interstitial?.load(request)
	}
	
	//Type font default
	func fontDefault() {
		if currentValueFont == "Arial" {
			print("FONTE SELECIONADA ARIAL")
		} else if currentValueFont == "Georgia" {
			print("FONTE SELECIONADA GEORGIA")
			print("APPDELEGATE \(currentValueFont!)")
		} else if currentValueFont == "Tahoma" {
			print("FONTE SELECIONADA TAHOMA")
			print("APPDELEGATE \(currentValueFont!)")
		} else if currentValueFont == "Avenir" {
			print("FONTE SELECIONADA AVENIR")
			print("APPDELEGATE \(currentValueFont!)")
		} else {
			print("FONTE SELECIONADA NENHUMA")
			print("APPDELEGATE \(String(describing: currentValueFont))")
			let fontInicialPadrao = "Avenir"
			UserDefaults.standard.set(fontInicialPadrao, forKey: "fontSelected")
			UserDefaults.standard.synchronize()
		}
	}
	
	//Color Background default
	func backColor() {
		if currentColorBack == "black" {
			print("COR BLACK SELECIONADO")
		} else if currentColorBack == "white" {
			print("COR WHITE SELECIONADO")
		} else {
			print("NENHUM COR DE FUNDO")
			let colorBackgroundPadrao = "white"
			UserDefaults.standard.set(colorBackgroundPadrao, forKey: "colorBackSelected")
			UserDefaults.standard.synchronize()
		}
	}

	func checkUserIsLogin() {
		//Checa se o usuario está logado
		if #available(iOS 13.0, *) {
			SignInWithAppleManager.checkUserAuth { (authState) in
				switch authState {
				case .undefined:
					if Auth.auth().currentUser?.uid == nil {
						self.perform(#selector(self.handleLogout), with: nil, afterDelay: 0)
					} else {
						print("Usuario Logado")
					}
				case .signedOut:
					if Auth.auth().currentUser?.uid == nil {
						self.perform(#selector(self.handleLogout), with: nil, afterDelay: 0)
					} else {
						print("Usuario Logado")
					}
//					let controller = InicioLogin()
//					controller.modalPresentationStyle = .fullScreen
//					controller.delegate = self
//					self.present(controller, animated: true, completion: nil)
				case .signedIn:
					print("signedIn")
				}
			}
		} else {
			// Fallback on earlier versions
			if Auth.auth().currentUser?.uid == nil {
				self.perform(#selector(self.handleLogout), with: nil, afterDelay: 0)
			} else {
				print("Usuario Logado")
			}
		}
//		if Auth.auth().currentUser?.uid == nil {
//			perform(#selector(handleLogout), with: nil, afterDelay: 0)
//		} else {
//			print("Usuario Logado")
//		}
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		reachability?.stopNotifier()
		NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		showBannerInstertitial()
	}

	
	func showBannerInstertitial() {
		if interstitial?.isReady ?? false {
			interstitial?.present(fromRootViewController: self)
		} else {
			print("Interstitial Não Está Pronto")
		}
	}
	
	@objc func reachabilityChanged(note: Notification) {
		let reachability = note.object as! Reachability
		
		switch reachability.connection {
		case .wifi:
			print("Reachable via WiFi")
		case .cellular:
			print("Reachable via Cellular")
			let alertController = UIAlertController(title: "Acesso a Internet Via Operadora", message: "Alguns recursos podem consumir seu plano de dados.", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
		case .none:
			print("Network not reachable")
			let alertController = UIAlertController(title: "Sem Conexão com a Internet", message: "Alguns recursos estarão desativados.", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
        case .unavailable:
            print("Default Value Unavailable")
        }
	}
	
	override func viewDidAppear(_ animated: Bool) {
		navigationController?.hidesBarsOnSwipe = false
		
		
	}
	
	@objc func handleLogout() {
		do {
			try Auth.auth().signOut()
		} catch let logoutError {
			print(logoutError)
		}
	
		let loginPage = Login()
        loginPage.modalPresentationStyle = .fullScreen
		present(loginPage, animated: true, completion: nil)

	}
	
	@objc func handleBookmark() {
		
		let createBookmarkController = BookmarkController()
		
		let navControllerBookmark = UINavigationController(rootViewController: createBookmarkController)
		
		createBookmarkController.favoritosBook = self
        navControllerBookmark.modalPresentationStyle = .fullScreen
		
		present(navControllerBookmark, animated: true, completion: nil)
		
	}
	
	func logoNavigationBar() {
		//Defini o Logo no Navigation Bar
		let imageView = UIImageView(image: UIImage(named: "logo-app-bar"))
		imageView.contentMode = .scaleAspectFit
		let titleView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(26), height: CGFloat(32)))
		imageView.frame = titleView.bounds
		titleView.addSubview(imageView)
		navigationItem.titleView = titleView
	}

	func fetchListHinos() {
		
		Database.database().reference().child("hinos").observe(.childAdded, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String:AnyObject] {
				guard let nameHino = dictionary["name"] else { return }
				let numberHino = snapshot.key
				guard let groupsHino = dictionary["groups"] else { return }
				guard let authHino = dictionary["compositor"] else { return }
				guard let imageHino = dictionary["image"] else { return }
				guard let imageURLHino = dictionary["imageURL"] else { return }
				guard let music = dictionary["music"] else { return }
				guard let musicURL = dictionary["musicURL"] else { return }
				guard let estrofeUm = dictionary["estrofeUm"] else { return }
				guard let estrofeDois = dictionary["estrofeDois"] else { return }
				guard let estrofeTres = dictionary["estrofeTres"] else { return }
				guard let estrofeQuatro = dictionary["estrofeQuatro"] else { return }
				guard let estrofeCinco = dictionary["estrofeCinco"] else { return }
				guard let estrofeCoroNormal = dictionary["estrofeCoroNormal"] else { return }
				guard let estrofeCoroInicio = dictionary["estrofeCoroInicio"] else { return }
				let ref = snapshot.ref

				self.favoritableHinos.append(Hinario(name: "\(nameHino)", number: numberHino, groups: "\(groupsHino)", hasFavorited: false, compositor: "\(authHino)", image: "\(imageHino)", imageURL: "\(imageURLHino)", music: "\(music)", musicURL: "\(musicURL)", estrofeUm: "\(estrofeUm)", estrofeDois: "\(estrofeDois)", estrofeTres: "\(estrofeTres)", estrofeQuatro: "\(estrofeQuatro)", estrofeCinco: "\(estrofeCinco)", estrofeCoroNormal: "\(estrofeCoroNormal)", estrofeCoroInicio: "\(estrofeCoroInicio)", ref: ref))
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
					SVProgressHUD.dismiss()
				}
			}
		}, withCancel: nil)
		
		
	}

}

extension HinosController: InicioLoginControllerDelegate {
	func didFinishAuth() {
		if #available(iOS 13.0, *) {
			print("\(String(describing: UserDefaults.standard.string(forKey: SignInWithAppleManager.userIdentifierKey)))")
		} else {
			// Fallback on earlier versions
		}
		
	}
}
