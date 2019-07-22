//
//  BookmarkController.swift
//  Hinário
//
//  Created by Ewerson Castelo on 29/12/2017.
//  Copyright © 2017 Ewerson Castelo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
import SVProgressHUD

class BookmarkController: UITableViewController {

	var favoritosBook: HinosController?
	let cellId = "cellIdBook"
	var listaFavoritos = [Favorito]()
	
	//Banner Admob
	var interstitial: GADInterstitial?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		navigationItem.title = "Hinos Favoritos"
		
		tableView.register(BookmarkCell.self, forCellReuseIdentifier: cellId)
		
		view.backgroundColor = .white
		tableView.backgroundColor = .lightGray
		tableView.tableFooterView = UIView() //let blank UIview footer
		//Ativando o Self Sizing Class
		tableView.estimatedRowHeight = 70
		tableView.rowHeight = UITableView.automaticDimension
		tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
		tableView.separatorColor = UIColor.verdeTitulo
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(handleCancel))
		
		//Logo do Aplicativo
		logoApp()
		
		fetchBannerADSfavor()

	}
	
	func fetchBannerADSfavor() {
		//Primeiro Banner
		interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") //Apenas Para Testes
//		interstitial = GADInterstitial(adUnitID: "ca-app-pub-1249842998763621/1161129630")
		let request = GADRequest()
		interstitial?.load(request)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		if interstitial?.isReady ?? false {
			interstitial?.present(fromRootViewController: self)
		} else {
			print("Ad Intertitial wasn't ready")
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		listaFavoritos = carregarDados()
		atualizaViewFavoritos()
		tableView.reloadData()
		print("Trocada de TabItem")
	}
	
	func carregarDados() -> [Favorito]{
		
		var listafavoritos:[Favorito] = []
		var listaTitulos:[String] = []
		var listaNumber:[String] = []
		var listaAuth:[String] = []
		var listaMusic:[String] = []
		var listaMusicUrl:[String] = []
		var listaEstrofeUm:[String] = []
		var listaEstrofeDois:[String] = []
		var listaEstrofeTres:[String] = []
		var listaEstrofeQuatro:[String] = []
		var listaEstrofeCinco:[String] = []
		var listaEstrofeCoroNormal:[String] = []
		var listaEstrofeCoroInicio:[String] = []
		var listaRefHino:[String] = []
		
		if(UserDefaults.standard.object(forKey: "Lista Titulos") != nil){
			listaTitulos = UserDefaults.standard.object(forKey: "Lista Titulos") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista Datas") != nil){
			listaNumber = UserDefaults.standard.object(forKey: "Lista Datas") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista Auths") != nil){
			listaAuth = UserDefaults.standard.object(forKey: "Lista Auths") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista Music") != nil){
			listaMusic = UserDefaults.standard.object(forKey: "Lista Music") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista MusicUrl") != nil){
			listaMusicUrl = UserDefaults.standard.object(forKey: "Lista MusicUrl") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista EstrofeUm") != nil){
			listaEstrofeUm = UserDefaults.standard.object(forKey: "Lista EstrofeUm") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista EstrofeDois") != nil){
			listaEstrofeDois = UserDefaults.standard.object(forKey: "Lista EstrofeDois") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista EstrofeTres") != nil){
			listaEstrofeTres = UserDefaults.standard.object(forKey: "Lista EstrofeTres") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista EstrofeQuatro") != nil){
			listaEstrofeQuatro = UserDefaults.standard.object(forKey: "Lista EstrofeQuatro") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista EstrofeCinco") != nil){
			listaEstrofeCinco = UserDefaults.standard.object(forKey: "Lista EstrofeCinco") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista EstrofeCoroNormal") != nil){
			listaEstrofeCoroNormal = UserDefaults.standard.object(forKey: "Lista EstrofeCoroNormal") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista EstrofeCoroInicio") != nil){
			listaEstrofeCoroInicio = UserDefaults.standard.object(forKey: "Lista EstrofeCoroInicio") as! [String]
		}
		
		if(UserDefaults.standard.object(forKey: "Lista RefFavorito") != nil){
			listaRefHino = UserDefaults.standard.object(forKey: "Lista RefFavorito") as! [String]
		}
		
		if(listaTitulos.count > 0){
			var contador:Int = 0
			for item in listaTitulos{
				
				let novoFavorito:Favorito = Favorito(nameFav: item, numberFav: listaNumber[contador], authFav: listaAuth[contador], musicFav: listaMusic[contador], musicUrlFav: listaMusicUrl[contador], estrofeUmFav: listaEstrofeUm[contador], estrofeDoisFav: listaEstrofeDois[contador], estrofeTresFav: listaEstrofeTres[contador], estrofeQuatroFav: listaEstrofeQuatro[contador], estrofeCincoFav: listaEstrofeCinco[contador], estrofeCoroNormalFav: listaEstrofeCoroNormal[contador], estrofeCoroInicioFav: listaEstrofeCoroInicio[contador], listaRefHino: listaRefHino[contador])
				
				listafavoritos.append(novoFavorito)
				contador += 1
			}
		}
		return listafavoritos
	}
	
	func atualizaViewFavoritos() {
		if listaFavoritos.count == 0  {
//			tableView.isHidden = true
			let alertController = UIAlertController(title: "Atenção!", message: "Você não possui favoritos salvos!", preferredStyle: .alert)
			
			let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler: { (UIAlertAction) in
//				self.levaTelaInicio()
			})
			alertController.addAction(defaultAction)
			
			self.present(alertController, animated: true, completion: nil)
		}else{
//			tableView.isHidden = false
			print("Tem \(listaFavoritos.count) Favorito")
		}
		
	}
	
	@objc func handleCancel() {
		dismiss(animated: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listaFavoritos.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BookmarkCell
		
		let hinarioFav = listaFavoritos[indexPath.row]
		
		cell.nameHinoFav.text = hinarioFav.nameFav
		cell.numberHinoFav.text = hinarioFav.numberFav
		cell.authHinoFav.text = hinarioFav.authFav
		
		cell.textLabel?.textColor = UIColor.gray
		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
				
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let bookDetailController = BookDetailController()
		
		bookDetailController.hinariosFavDetail = listaFavoritos[indexPath.row]
		
		//Deixa o Botão Voltar sem Título
		let backItem = UIBarButtonItem()
		backItem.title = "Voltar"
		navigationItem.backBarButtonItem = backItem
		
		navigationController?.pushViewController(bookDetailController, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Remover") { (action, indexPath) in
			self.listaFavoritos.remove(at: indexPath.row)
			self.tableView.reloadData()
			self.atualizaViewFavoritos()
			self.salvarDados(listafavoritos: self.listaFavoritos)
		}
		delete.backgroundColor = .verdeTitulo
		self.atualizaViewFavoritos()
		return [delete]
	}
	
	func salvarDados(listafavoritos:[Favorito]){
		
		var listaTitulos:[String] = []
		var listaNumber:[String] = []
		var listaAuth:[String] = []
		var listaMusic:[String] = []
		var listaMusicUrl:[String] = []
		var listaEstrofeUm:[String] = []
		var listaEstrofeDois:[String] = []
		var listaEstrofeTres:[String] = []
		var listaEstrofeQuatro:[String] = []
		var listaEstrofeCinco:[String] = []
		var listaEstrofeCoroNomal:[String] = []
		var listaEstrofeCoroInicio:[String] = []
		var listaRefHino:[String] = []
		
		for item in listafavoritos{
			listaTitulos.append(item.nameFav)
			listaNumber.append(item.numberFav)
			listaAuth.append(item.authFav)
			listaMusic.append(item.musicFav)
			listaMusicUrl.append(item.musicUrlFav)
			listaEstrofeUm.append(item.estrofeUmFav)
			listaEstrofeDois.append(item.estrofeDoisFav)
			listaEstrofeTres.append(item.estrofeTresFav)
			listaEstrofeQuatro.append(item.estrofeQuatroFav)
			listaEstrofeCinco.append(item.estrofeCincoFav)
			listaEstrofeCoroNomal.append(item.estrofeCoroNormalFav)
			listaEstrofeCoroInicio.append(item.estrofeCoroInicioFav)
			listaRefHino.append(item.listaRefHino)
		}
		
		UserDefaults.standard.set(listaTitulos, forKey: "Lista Titulos")
		UserDefaults.standard.set(listaNumber, forKey: "Lista Datas")
		UserDefaults.standard.set(listaAuth, forKey: "Lista Auths")
		UserDefaults.standard.set(listaMusic, forKey: "Lista Music")
		UserDefaults.standard.set(listaMusicUrl, forKey: "Lista MusicUrl")
		UserDefaults.standard.set(listaEstrofeUm, forKey: "Lista EstrofeUm")
		UserDefaults.standard.set(listaEstrofeDois, forKey: "Lista EstrofeDois")
		UserDefaults.standard.set(listaEstrofeTres, forKey: "Lista EstrofeTres")
		UserDefaults.standard.set(listaEstrofeQuatro, forKey: "Lista EstrofeQuatro")
		UserDefaults.standard.set(listaEstrofeCinco, forKey: "Lista EstrofeCinco")
		UserDefaults.standard.set(listaEstrofeCoroNomal, forKey: "Lista EstrofeCoroNormal")
		UserDefaults.standard.set(listaEstrofeCoroInicio, forKey: "Lista EstrofeCoroInicio")
		UserDefaults.standard.set(listaEstrofeCoroInicio, forKey: "Lista RefFavorito")
	}
	
	private func logoApp() {
		//Defini o Logo no Navigation Bar
		let imageView = UIImageView(image: UIImage(named: "logo-app-bar"))
		imageView.contentMode = .scaleAspectFit
		let titleView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(26), height: CGFloat(32)))
		imageView.frame = titleView.bounds
		titleView.addSubview(imageView)
		navigationItem.titleView = titleView
	}
		
	
}
