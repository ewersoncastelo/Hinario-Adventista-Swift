//
//  BookmarkDetailController.swift
//  Hinário
//
//  Created by Ewerson Castelo on 18/02/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
//import Kingfisher
import InAppPurchaseButton
import AVFoundation
import MediaPlayer
import SystemConfiguration
import GoogleMobileAds
import Reachability
import WebKit

class BookDetailController: UIViewController, UIScrollViewDelegate {

//	let reachability = Reachability()
	let reachability = try? Reachability()
	var hinariosFavDetail: Favorito!
	
	//Variavel da Classe favoritos
	var listaFavoritos:[Favorito] = []
	var favoritado:Bool = false
	
	let storage = Storage.storage().reference()
	let imageRef = Storage.storage().reference(withPath: "images")
	let musicRef = Storage.storage().reference(withPath: "music")
	
	var currentValueSlider = UserDefaults.standard.integer(forKey: "sliderValue")
	var currentValueFont = UserDefaults.standard.string(forKey: "fontSelected")!
	var currentColorBack = UserDefaults.standard.string(forKey: "colorBackSelected")!
	var currentModoDiaNoite = UserDefaults.standard.bool(forKey: "diaNoiteModoSelected")
	
	var isOn = true
	var audioPlayer = AVAudioPlayer()
	
	private let viewTipoFonte: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(red: 111/255, green: 113/255, blue: 121/255, alpha: 1)
		return view
	}()
	
	private let viewSlider: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor.lightGray
		return view
	}()
	
	private let viewControlsSound: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor.tituloDois
		return view
	}()
	
	private let viewWebView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private var musicStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.alignment = .fill
		stack.distribution = .fill
		stack.spacing = 0
//		stack.heightAnchor.constraint(equalToConstant: 60)
		return stack
	}()
	
	private let arialButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Arial", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
		button.setTitleColor( .white, for: .normal)
		button.addTarget(self, action: #selector(handleArial), for: .touchUpInside)
		button.tintColor = .white
		return button
	}()
	
	private let georgiaButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Georgia", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
		button.setTitleColor( .white, for: .normal)
		button.addTarget(self, action: #selector(handleGeorgia), for: .touchUpInside)
		button.tintColor = .white
		return button
	}()
	
	private let avenirButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Avenir", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
		button.setTitleColor( .white, for: .normal)
		button.addTarget(self, action: #selector(handleAvenir), for: .touchUpInside)
		button.tintColor = .white
		return button
	}()
	
	private let tahomaButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Tahoma", for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
		button.setTitleColor( .white, for: .normal)
		button.addTarget(self, action: #selector(handleTahoma), for: .touchUpInside)
		button.tintColor = .white
		return button
	}()
	
	private let tamanhoLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Tamanho"
		label.textColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)
		label.font = UIFont.preferredFont(forTextStyle: .subheadline)
		return label
	}()
	
	private let fonteSizeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "26 px"
		label.textColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)
		label.font = UIFont.preferredFont(forTextStyle: .subheadline)
		return label
	}()
	
	private let slider: UISlider = {
		let sliderButtom = UISlider()
		sliderButtom.value = 13
		sliderButtom.minimumValue = 8
		sliderButtom.maximumValue = 16
		sliderButtom.translatesAutoresizingMaskIntoConstraints = false
		sliderButtom.tintColor = .verdeTitulo
		sliderButtom.isContinuous = true
		sliderButtom.addTarget(self, action: #selector(sliderChangeValue(_:)), for: .valueChanged)
		return sliderButtom
	}()
	
	private let playPauseButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
		button.tintColor = .white
		return button
	}()
	
	private let restartButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "restart"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleRestart), for: .touchUpInside)
		button.tintColor = .white
		return button
	}()
	
	private let prevFast: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "prevIcon"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
		button.tintColor = .white
		return button
	}()
	
	private let nextFast: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "next-Icon"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
		button.tintColor = .white
		return button
	}()
	
	private let stopButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "stopIcon"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(handleStop), for: .touchUpInside)
		button.tintColor = .white
		return button
	}()
	
	private let downloadMusic: InAppPurchaseButton = {
		let button = InAppPurchaseButton(type: .custom)
		button.setImage(#imageLiteral(resourceName: "download"), for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.tintColor = .white
		button.addTarget(self, action: #selector(fazerDownload(_:)), for: .touchUpInside)
		button.cornerRadiusForExpandedBorder = 8
		button.borderWidthForProgressView = 4
		button.shouldAlwaysDisplayBorder = false
		return button
	}()
	
	private let progressView: UIProgressView = {
		let progress = UIProgressView()
		progress.translatesAutoresizingMaskIntoConstraints = false
		progress.progressViewStyle = .default
		progress.trackTintColor = .white
		progress.progressTintColor = UIColor.verdeTitulo
		progress.progress = 0.0
		return progress
	}()
	
	private let musicPlayerLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "00:00"
		label.textColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)
		label.font = UIFont.boldSystemFont(ofSize: 11)
		return label
	}()
	
	private let myWebView: WKWebView! = {
		let webView = WKWebView()
		webView.translatesAutoresizingMaskIntoConstraints = false
		return webView
	}()
	
	private var stackTrackSound: UIStackView = {
		let stack = UIStackView()
		return stack
	}()
	
	private var allStackViewAreasLayout: UIStackView = {
		let stack = UIStackView()
		return stack
	}()
	
	private let buttomDiaEnoite: UIBarButtonItem = {
		let buttom = UIBarButtonItem(image: #imageLiteral(resourceName: "nigth"), style: .plain, target: self, action: #selector(modoDiaNoite))
		buttom.tintColor = .yellow
		return buttom
	}()
	
	private let buttomControlPainel: UIBarButtonItem = {
		let buttom = UIBarButtonItem(image: #imageLiteral(resourceName: "music-custom"), style: .plain, target: self, action: #selector(handleControlsPainel))
		buttom.tintColor = .lightBlue
		return buttom
	}()
	
	private var buttomFavoritar: UIBarButtonItem = {
		let buttom = UIBarButtonItem(image: #imageLiteral(resourceName: "star-icon"), style: .plain, target: self, action: #selector(handleFavoritar))
		buttom.tintColor = .white
		return buttom
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Função Favoritos
		listaFavoritos = carregarDados()
		verificaEstadoBotaoFavorito()
		
		view.backgroundColor = UIColor.white
		
		navigationItem.title = hinariosFavDetail.nameFav
		
		logoNavigationBar()
		
		setupTopControls()
		
		//Status inicial da personalização da fonte
		allStackViewAreasLayout.isHidden = true
		
		//Faz download do HTML e das Imagens
		downloadImagemWebView()
		
		//Tamanho Fonte
		sizeFontHino()
		
		//Tipo Fonte
		typeFontHino()
		
		//Dia ou Noite
		dayOrNigth()
		
		myWebView?.scrollView.delegate = self
		
		//Define o Ícone conforme o status do download da música
		statusDownloadMusic()
		
		//Preparar Player de Som
		playingSong()
		
		//Condição Inicial dos Controle de Som
		playPauseButton.isEnabled = false
		restartButton.isEnabled = false
		downloadMusic.isEnabled = false
		musicPlayerLabel.isEnabled = false
		prevFast.isEnabled = false
		nextFast.isEnabled = false
		stopButton.isEnabled = false
		progressView.isOpaque = true
		
		//Setar Sessão do Audio
		setSession()
		UIApplication.shared.beginReceivingRemoteControlEvents()
		becomeFirstResponder()
		NotificationCenter.default.addObserver(self, selector: Selector(("handleInterruption")), name: AVAudioSession.interruptionNotification, object: nil)
		
		self.navigationItem.setRightBarButtonItems([buttomControlPainel, buttomDiaEnoite, buttomFavoritar], animated: true)
		
		print("-----------------\(hinariosFavDetail.listaRefHino)")
		
	}
	
	func verificaEstadoBotaoFavorito(){
		if(verificaFavorito(idName: "\(hinariosFavDetail.nameFav)")){
			buttomFavoritar.tintColor = .red
		} else {
			buttomFavoritar.tintColor = .white
		}
	}
	
	func verificaFavorito(idName:String) -> Bool{
		var respostaFavorito:Bool = false
		for item in listaFavoritos {
			if(item.nameFav == idName){
				respostaFavorito = true
				favoritado = respostaFavorito
				print("O Hino: \(item.nameFav) já está favoritado")
			}
		}
		
		if !respostaFavorito {print("Nenhum favorito encontrado com o Hino \(idName)")}
		return respostaFavorito
	}
	
	func adicionaFavoritos(favorito:Favorito) {
		listaFavoritos.append(favorito)
		salvarDados(listafavoritos: listaFavoritos)
	}
	
	func removeFavorito(idName:String){
		var contador:Int = 0
		for item in listaFavoritos {
			if(item.nameFav == idName){
				listaFavoritos.remove(at: contador)
				salvarDados(listafavoritos: listaFavoritos)
			}
			contador += 1
		}
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
		UserDefaults.standard.set(listaRefHino, forKey: "Lista RefFavorito")
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
	
	@objc private func handleFavoritar() {
		print("tentando favoritar")
		favoritado = !favoritado
		if(favoritado) {
			buttomFavoritar.tintColor = .red
			
			let novoFavorito:Favorito = Favorito(nameFav: hinariosFavDetail.nameFav, numberFav: hinariosFavDetail.numberFav, authFav: hinariosFavDetail.authFav, musicFav: hinariosFavDetail.musicFav, musicUrlFav: hinariosFavDetail.musicUrlFav, estrofeUmFav: hinariosFavDetail.estrofeUmFav, estrofeDoisFav: hinariosFavDetail.estrofeDoisFav, estrofeTresFav: hinariosFavDetail.estrofeTresFav, estrofeQuatroFav: hinariosFavDetail.estrofeQuatroFav, estrofeCincoFav: hinariosFavDetail.estrofeCincoFav, estrofeCoroNormalFav: hinariosFavDetail.estrofeCoroNormalFav, estrofeCoroInicioFav: hinariosFavDetail.estrofeCoroInicioFav, listaRefHino: hinariosFavDetail.listaRefHino)
			
			adicionaFavoritos(favorito: novoFavorito)
			
		} else {
			buttomFavoritar.tintColor = .white
			removeFavorito(idName: hinariosFavDetail.nameFav)
		}
	}
	
	override var canBecomeFirstResponder: Bool {
		return true
	}
	
	//Download URL do SOM em Tem Files
	func downloadFileFromURL(url:NSURL){
		var downloadTask:URLSessionDownloadTask
		downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { (URLt, response, error) -> Void in
			self.play(url: URLt! as NSURL)
		})
		downloadTask.resume()
	}
	
	//Fução Carregar Musica de URL
	func play(url:NSURL) {
		print("playing \(url)")
		do {
			self.audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
			setPlayingScreen(fileUrl: "\(url)")
			audioPlayer.prepareToPlay()
			//resolve o problema de roda em segundo plano
			DispatchQueue.main.async(execute: {
				UIApplication.shared.registerForRemoteNotifications()
				self.playPauseButton.isEnabled = true
				self.restartButton.isEnabled = true
				self.downloadMusic.isEnabled = true
				self.musicPlayerLabel.isEnabled = true
				Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateAudioProgressView), userInfo: nil, repeats: true)
				Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateTimeLabelMusic), userInfo: nil, repeats: true)
				self.progressView.setProgress(Float(self.audioPlayer.currentTime/self.audioPlayer.duration), animated: false)
			})
			
		} catch let error as NSError {
			//self.player = nil
			print(error.localizedDescription)
		} catch {
			print("AVAudioPlayer init failed")
		}
		
	}
	
	@objc func fazerDownload(_ sender: InAppPurchaseButton) {
		
		print("Botao Press Music")
		let path = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		let filePath = path.appendingPathComponent("\(hinariosFavDetail.musicFav)")
		let fileManager = FileManager.default
		
		//Se não houver Link de Imagem URL válida Usar iMagem Padrão
		if (hinariosFavDetail.musicUrlFav == "nil" || hinariosFavDetail.musicUrlFav == "") {
			
			print("Usando arquivo Música da internet")
			
		} else if !fileManager.fileExists(atPath: "\(filePath.path)") {
			
			print("Baixando Musica da Internet")
			
			//Cria uma referencia do arquivo
			let musicDownRef = storage.child("music/\(hinariosFavDetail.musicFav)")
			
			let downloadProgressMusic = musicDownRef.write(toFile: filePath) { (URL, error) in
				if (error != nil) {
					print("Erro ao Baixar Musica")
					print(error.debugDescription)
				} else {
					print("Baixado musica em: \(filePath)")
				}
			}
			
			// Add a progress observer to a download task
			_ = downloadProgressMusic.observe(.progress) { (snapshot) -> Void in
				
				let percentComplete = CGFloat(snapshot.progress!.completedUnitCount) / CGFloat(snapshot.progress!.totalUnitCount)
				
				self.downloadMusic.imageForInactiveState = UIImage(named: "download")
				self.downloadMusic.imageForActiveState = UIImage(named: "down-full")
				
				switch sender.buttonState {
				case .downloading(progress: 1.0):
					print("Progress 1.0")
					sender.buttonState = .regular(animate: true, intermediateState: .active)
				case .downloading(progress: 0.0):
					print("Progresso 0.0")
				case .regular(animate: true, intermediateState: .active):
					print("Botão Ativo")
				case .regular(false, _):
					print("Estado Intermediario")
					sender.buttonState = .busy(animate: true)
					sender.buttonState = .downloading(progress: CGFloat(percentComplete))
					self.downloadMusic.setImage(UIImage(named:""), for: .normal)
				case .downloading( _):
					print("Progresso")
					sender.buttonState = .busy(animate: false)
					sender.buttonState = .downloading(progress: CGFloat(percentComplete))
				default:
					print("Default")
					break
				}
			}
		} else {
			print("USANDO ARQUIVO LOCAL")
		}
	}
	
	func statusDownloadMusic() {
		let pathIcon = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		let filePathIcon = pathIcon.appendingPathComponent("\(hinariosFavDetail.musicFav)")
		let fileManagerIcon = FileManager.default
		if !fileManagerIcon.fileExists(atPath: "\(filePathIcon.path)") {
			print("----NÃO EXISTE ARQUIVO----")
		} else {
			print("----EXISTE ARQUIVO----")
			downloadMusic.setImage(UIImage(named:"down-full"), for: .normal)
		}
	}
	
	func playingSong() {
		
		let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		// create a name for your music
		let fileURL = documentsDirectoryURL.appendingPathComponent("\(hinariosFavDetail.musicFav)")
		
		if !FileManager.default.fileExists(atPath: fileURL.path) {
			
			print("NÃO HÁ MUSICA NO DIRETÓRIO \(fileURL.path)")
			
			if hinariosFavDetail.musicUrlFav == "nil" || hinariosFavDetail.musicUrlFav == "" {
				print("Sem URL DE MUSICA PARA TOCAR")
			} else {
				switch reachability?.connection {
				case .wifi:
					print("Play Music Já Baixada ou Online")
					let musicURLonline = hinariosFavDetail.musicUrlFav
					guard let urlMusic = NSURL(string: musicURLonline) else { return }
					downloadFileFromURL(url: urlMusic)
				case .cellular:
					print("Play Music Já Baixada ou Online")
					let musicURLonline = hinariosFavDetail.musicUrlFav
					guard let urlMusic = NSURL(string: musicURLonline) else { return }
					downloadFileFromURL(url: urlMusic)
				case .none:
					print("Não Baixar Audio File")
				case .unavailable:
					print("Value Default Unavailable")
				case .some(.none):
					print("default value none")
				}
			}
			
		} else {
			
			print("HÁ ARQUIVO SALVO NO DIRETÓRIO LOCAL")
			print(fileURL)
			
			let urlMusic = fileURL
			do {
				audioPlayer = try AVAudioPlayer(contentsOf: urlMusic as URL)
				setPlayingScreen(fileUrl: "\(urlMusic)")
				audioPlayer.prepareToPlay()
				Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
				progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: false)
				Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateTimeLabelMusic), userInfo: nil, repeats: true)
				
				//resolve o problema de roda em segundo plano
				DispatchQueue.main.async(execute: {
					UIApplication.shared.registerForRemoteNotifications()
					self.playPauseButton.isEnabled = true
					self.restartButton.isEnabled = true
					self.downloadMusic.isEnabled = true
					self.musicPlayerLabel.isEnabled = true
				})
			}
			catch {
				print(error)
			}
		}
	}
	
//	override func viewWillAppear(_ animated: Bool) {
//		NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
//		do{
//			try reachability.startNotifier()
//		}catch{
//			print("could not start reachability notifier")
//		}
//	}
	
	override func viewDidAppear(_ animated: Bool) {
		if isOn == true {
			print("FUNDO PRETO")
			myWebView.backgroundColor = .black
			viewWebView.backgroundColor = .black
			buttomDiaEnoite.tintColor = .darkGray
		} else {
			print("FUNDO BRANO")
			myWebView.backgroundColor = .white
			viewWebView.backgroundColor = .white
			buttomDiaEnoite.tintColor = UIColor(red: 252.0/255.0, green: 221.0/255.0, blue: 74.0/255.0, alpha: 1.0)
		}
		for item in listaFavoritos {
			print(item.nameFav)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		checkReachabilityStopMusic()
	}
	
	func checkReachabilityStopMusic() {
		
		switch reachability?.connection {
		case .wifi:
			if playPauseButton.isEnabled == false {
				print("Botão PLAY Desativado")
			} else {
				print("Botão Stop Ativado")
				audioPlayer.stop()
			}
		case .cellular:
			print("Internet no Detail")
			if playPauseButton.isEnabled == false {
				print("Botão PLAY Desativado")
			} else {
				print("Botão Stop Ativado")
				audioPlayer.stop()
			}
			
		case .none:
			print("Network not reachable")
			if playPauseButton.isEnabled == false {
				print("Botão PLAY Desativado")
			} else {
				print("Botão Stop Ativado")
				audioPlayer.stop()
			}
		case .unavailable:
			print("Value Default Unavailable")
		case .some(.none):
			print("default value none")
		}
		
	}
	
	@objc func reachabilityChanged(note: Notification) {
		
		let reachability = note.object as! Reachability
		
		switch reachability.connection {
		case .wifi:
			print("Internet Para Ativaro Play")
			//Status Inicial do Botão PLAY
			if playPauseButton.isEnabled == false {
				print("Aguarde um instante...")
//				SVProgressHUD.show()
			}
		case .cellular:
			print("Reachable via Cellular")
			let alertController = UIAlertController(title: "Acesso a Internet Via Operadora", message: "Alguns recursos podem consumir seu plano de dados.", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
			
			print("Internet Para Ativar o Play")
			//Status Inicial do Botão PLAY
			if playPauseButton.isEnabled == false {
				print("Aguarde um instante...")
//				SVProgressHUD.show()
			}
		case .none:
			print("Network not reachable")
			print("Sem Internet para usar o recurso")
			let alertController = UIAlertController(title: "Sem Conexão com a Internet", message: "Você pode continuar usando normalmente o Aplicativo, alguns recursos serão apenas desativados.", preferredStyle: .alert)
			let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
			alertController.addAction(defaultAction)
			self.present(alertController, animated: true, completion: nil)
        case .unavailable:
            print("Value default unavailable")
        }
	}
	
	private func animateView(view: UIView, toHidden hidden: Bool) {
		UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIView.AnimationOptions(), animations: {
			view.isHidden = hidden
		}, completion: nil)
	}
	
	@objc func sliderChangeValue(_ sender: Any) {
		
		let senderValue = Int(slider.value)
		
		var defaults  = ["textFontSize":6]
		
		var textFontSizeTemp = defaults["textFontSize"]! as Int
		
		switch senderValue {
		case 8: //when decrease
			textFontSizeTemp  = 8
		case 9: //when increase
			textFontSizeTemp  = 9
		case 10: //when decrease
			textFontSizeTemp  = 10
		case 11: //when increase
			textFontSizeTemp  = 11
		case 12: //when decrease
			textFontSizeTemp  = 12
		case 13: //when increase
			textFontSizeTemp  = 13
		case 14: //when decrease
			textFontSizeTemp  = 14
		case 15: //when increase
			textFontSizeTemp  = 15
		case 16:
			textFontSizeTemp  = 16
		default:
			textFontSizeTemp = 13
		}
		
		defaults["textFontSize"] = textFontSizeTemp
		
		let jsString = "document.getElementsByTagName('body')[0].style.fontSize='\(textFontSizeTemp)vw'"
		myWebView.evaluateJavaScript(jsString, completionHandler: nil)
		
		fonteSizeLabel.text = "\(textFontSizeTemp)px"
		
		UserDefaults.standard.set(senderValue, forKey: "sliderValue")
		UserDefaults.standard.synchronize()
		
	}
	
	//Recupera TAMANHO FONTE salvo no UserDefaults
	func sizeFontHino() {
		slider.value = Float(currentValueSlider)
		fonteSizeLabel.text = "\(currentValueSlider)px"
	}
	
	@objc func handleArial() {
		var defaults  = ["textFontType":"Arial"]
		
		let textFontTypeTemp = defaults["textFontType"]! as String
		
		defaults["textFontType"] = textFontTypeTemp
		
		let jsString = "document.getElementsByTagName('body')[0].style.fontFamily='\(textFontTypeTemp)'"
		
		myWebView.evaluateJavaScript(jsString, completionHandler: nil)
		
		UserDefaults.standard.set(textFontTypeTemp, forKey: "fontSelected")
		UserDefaults.standard.synchronize()
		
		arialButton.isSelected = true
		georgiaButton.isSelected = false
		avenirButton.isSelected = false
		tahomaButton.isSelected = false
	}
	
	@objc func handleGeorgia() {
		var defaults  = ["textFontType":"Georgia"]
		
		let textFontTypeTemp = defaults["textFontType"]! as String
		
		defaults["textFontType"] = textFontTypeTemp
		
		let jsString = "document.getElementsByTagName('body')[0].style.fontFamily='\(textFontTypeTemp)'"
		
		myWebView.evaluateJavaScript(jsString, completionHandler: nil)
		
		UserDefaults.standard.set(textFontTypeTemp, forKey: "fontSelected")
		UserDefaults.standard.synchronize()
		
		arialButton.isSelected = false
		georgiaButton.isSelected = true
		avenirButton.isSelected = false
		tahomaButton.isSelected = false
	}
	
	@objc func handleAvenir() {
		var defaults  = ["textFontType":"Avenir"]
		
		let textFontTypeTemp = defaults["textFontType"]! as String
		
		defaults["textFontType"] = textFontTypeTemp
		
		let jsString = "document.getElementsByTagName('body')[0].style.fontFamily='\(textFontTypeTemp)'"
		
		myWebView.evaluateJavaScript(jsString, completionHandler: nil)
		
		UserDefaults.standard.set(textFontTypeTemp, forKey: "fontSelected")
		UserDefaults.standard.synchronize()
		
		arialButton.isSelected = false
		georgiaButton.isSelected = false
		avenirButton.isSelected = true
		tahomaButton.isSelected = false
	}
	
	@objc func handleTahoma() {
		var defaults  = ["textFontType":"Tahoma"]
		
		let textFontTypeTemp = defaults["textFontType"]! as String
		
		defaults["textFontType"] = textFontTypeTemp
		
		let jsString = "document.getElementsByTagName('body')[0].style.fontFamily='\(textFontTypeTemp)'"
		
		myWebView.evaluateJavaScript(jsString, completionHandler: nil)
		
		UserDefaults.standard.set(textFontTypeTemp, forKey: "fontSelected")
		UserDefaults.standard.synchronize()
		
		arialButton.isSelected = false
		georgiaButton.isSelected = false
		avenirButton.isSelected = false
		tahomaButton.isSelected = true
		
	}
	
	func typeFontHino(){
		//Tipo de Fonte Selecionada
		if currentValueFont == "Arial" {
			print("Fonte Selecionada Arial")
			georgiaButton.isSelected = false
			arialButton.isSelected = true
			avenirButton.isSelected = false
			tahomaButton.isSelected = false
		} else if currentValueFont == "Georgia" {
			print("Fonte Selecionada Georgia")
			georgiaButton.isSelected = true
			arialButton.isSelected = false
			avenirButton.isSelected = false
			tahomaButton.isSelected = false
		} else if currentValueFont == "Tahoma" {
			print("Fonte Selecionada Tahoma")
			georgiaButton.isSelected = false
			arialButton.isSelected = false
			avenirButton.isSelected = false
			tahomaButton.isSelected = true
		} else {
			print("Fonte Selecionada Avenir")
			georgiaButton.isSelected = false
			arialButton.isSelected = false
			avenirButton.isSelected = true
			tahomaButton.isSelected = false
		}
	}
	
	@objc func modoDiaNoite(_ sender: Any) {
		print("Modo dia e Noite")
		buttonPressed()
	}
	
	func buttonPressed() {
		activateButton(bool: !isOn)
		
		if isOn == true {
			print("BOTAO NOITE TAPPED")
			let diaNoiteModoSelected = true
			let colorBackground = "black"
			let jsStringFundo = "document.body.style.backgroundColor=\"\(colorBackground)\""
			myWebView.evaluateJavaScript(jsStringFundo, completionHandler: nil)
			
			UserDefaults.standard.set(colorBackground, forKey: "colorBackSelected")
			UserDefaults.standard.set(diaNoiteModoSelected, forKey: "diaNoiteModoSelected")
			UserDefaults.standard.synchronize()
			
			myWebView.backgroundColor = .black
			viewWebView.backgroundColor = .black
			buttomDiaEnoite.tintColor = UIColor.darkGray
		} else {
			print("BOTAO DIA TAPPED")
			let colorBackground = "white"
			let diaNoiteModoSelected = false
			let jsStringFundo = "document.body.style.backgroundColor=\"\(colorBackground)\""
			myWebView.evaluateJavaScript(jsStringFundo, completionHandler: nil)
			
			UserDefaults.standard.set(colorBackground, forKey: "colorBackSelected")
			UserDefaults.standard.set(diaNoiteModoSelected, forKey: "diaNoiteModoSelected")
			UserDefaults.standard.synchronize()
			
			myWebView.backgroundColor = .white
			viewWebView.backgroundColor = .white
			buttomDiaEnoite.tintColor = UIColor(red: 252.0/255.0, green: 221.0/255.0, blue: 74.0/255.0, alpha: 1.0)
		}
	}
	
	func activateButton(bool: Bool) { isOn = bool }
	
	func dayOrNigth() {
		if isOn == true {
			activateButton(bool: currentModoDiaNoite)
		} else {
			activateButton(bool: currentModoDiaNoite)
		}
	}
	
	@objc func handlePlay(_ sender: Any) {
		if audioPlayer.isPlaying {
			audioPlayer.pause()
		} else {
			audioPlayer.play()
			prevFast.isEnabled = true
			nextFast.isEnabled = true
			stopButton.isEnabled = true
		}
		changePlayButton()
	}
	
	@objc func handleRestart() {
		if audioPlayer.isPlaying {
			audioPlayer.currentTime = 0
			audioPlayer.play()
		} else {
			audioPlayer.play()
			prevFast.isEnabled = true
			nextFast.isEnabled = true
		}
	}
	
	@objc func handleStop(_ sender: Any) {
		audioPlayer.stop()
		audioPlayer.currentTime = 0
		progressView.progress = 0.0
	}
	
	@objc func handleNext() {
		var time: TimeInterval = audioPlayer.currentTime
		time += 5.0 // Go forward by 5 seconds
		if time > audioPlayer.duration {
			handleStop(self)
			nextFast.isEnabled = false
			prevFast.isEnabled = false
		} else {
			audioPlayer.currentTime = time
			prevFast.isEnabled = true
		}
	}
	
	@objc func handlePrev() {
		var time: TimeInterval = audioPlayer.currentTime
		time -= 5.0 // Go back by 5 seconds
		if time < 0 {
			handleStop(self)
			handlePlay(self)
			prevFast.isEnabled = false
			nextFast.isEnabled = true
		} else {
			audioPlayer.currentTime = time
		}
	}
	
	func changePlayButton() {
		if audioPlayer.isPlaying {
			playPauseButton.setImage(UIImage(named:"pauseIcon"), for: .normal)
		} else {
			playPauseButton.setImage(UIImage(named:"playIcon"), for: .normal)
		}
	}
	
	@objc func updateAudioProgressView() {
		if audioPlayer.isPlaying {
			// Update progress
			progressView.setProgress(Float(audioPlayer.currentTime/audioPlayer.duration), animated: true)
		}
	}
	
	@objc func updateTimeLabelMusic() {
		
		let currentTimeInSeconds = self.audioPlayer.currentTime
		
		let mins = currentTimeInSeconds / 60
		let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
		let timeformatter = NumberFormatter()
		timeformatter.minimumIntegerDigits = 2
		timeformatter.minimumFractionDigits = 0
		timeformatter.roundingMode = .down
		guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
			return
		}
		musicPlayerLabel.text = "\(minsStr):\(secsStr)"
	}
	
	// MARK: - PLAYER MUSIC FUNCIONS
	func setPlayingScreen(fileUrl: String) {
		
		
	}
	
	func setSession() {
		do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.default)
            } else {
                // Fallback on earlier versions
            }
		} catch {
			print(error.localizedDescription)
		}
	}
	
	override func remoteControlReceived(with event: UIEvent?) {
		if event?.type == UIEvent.EventType.remoteControl {
			if event!.subtype == UIEvent.EventSubtype.remoteControlPause {
				print("pause")
				audioPlayer.pause()
				changePlayButton()
			} else if event!.subtype == UIEvent.EventSubtype.remoteControlPlay {
				print("play")
				audioPlayer.play()
				changePlayButton()
			}
			
		}
	}
	
	func handleInterruption(notification: NSNotification) {
		audioPlayer.pause()
		
		let interruptionTypeAsObject = notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSNumber
		
		let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeAsObject.uintValue)
		
		if let type = interruptionType {
			if type == .ended {
				audioPlayer.play()
			}
		}
	}
	
	//Controle Layout
	fileprivate func setupTopControls() {
		
		view.addSubview(viewTipoFonte)
		NSLayoutConstraint.activate([
			viewTipoFonte.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			viewTipoFonte.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			viewTipoFonte.heightAnchor.constraint(equalToConstant: 40)
			])
		
		let stackView = UIStackView(arrangedSubviews: [arialButton, georgiaButton, avenirButton, tahomaButton])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.axis = .horizontal
		viewTipoFonte.addSubview(stackView)
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: viewTipoFonte.leadingAnchor, constant: 10),
			stackView.trailingAnchor.constraint(equalTo: viewTipoFonte.trailingAnchor, constant: -10),
			stackView.centerYAnchor.constraint(equalTo: viewTipoFonte.centerYAnchor)
			])
		
		view.addSubview(viewSlider)
		NSLayoutConstraint.activate([
			viewSlider.topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
			viewSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			viewSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			viewSlider.heightAnchor.constraint(equalToConstant: 35)
			])
		let stackSlider = UIStackView(arrangedSubviews: [tamanhoLabel, slider, fonteSizeLabel])
		stackSlider.translatesAutoresizingMaskIntoConstraints = false
		stackSlider.distribution = .fill
		stackView.alignment = .center
		stackSlider.spacing = 5
		stackSlider.axis = .horizontal
		viewSlider.addSubview(stackSlider)
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				stackSlider.leftAnchor.constraint(equalTo: viewSlider.safeAreaLayoutGuide.leftAnchor, constant: 10),
				stackSlider.rightAnchor.constraint(equalTo: viewSlider.safeAreaLayoutGuide.rightAnchor, constant: -10),
				stackSlider.topAnchor.constraint(equalTo: viewSlider.topAnchor, constant: 3),
				stackSlider.bottomAnchor.constraint(equalTo: viewSlider.bottomAnchor, constant: -3),
				])
		} else {
			NSLayoutConstraint.activate([
				stackSlider.leftAnchor.constraint(equalTo: viewSlider.leftAnchor, constant: 10),
				stackSlider.rightAnchor.constraint(equalTo: viewSlider.rightAnchor, constant: -10),
				stackSlider.topAnchor.constraint(equalTo: viewSlider.topAnchor, constant: 3),
				stackSlider.bottomAnchor.constraint(equalTo: viewSlider.bottomAnchor, constant: -3),
				])
		}
		
		view.addSubview(viewControlsSound)
		NSLayoutConstraint.activate([
			viewControlsSound.topAnchor.constraint(equalTo: view.topAnchor, constant: 71),
			viewControlsSound.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			viewControlsSound.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			])
		let stackControlSound = UIStackView(arrangedSubviews: [prevFast, playPauseButton, stopButton, restartButton, nextFast, downloadMusic])
		stackControlSound.translatesAutoresizingMaskIntoConstraints = false
		stackControlSound.distribution = .equalSpacing
		stackControlSound.alignment = .fill
		stackControlSound.axis = .horizontal
		stackControlSound.spacing = 0
		viewControlsSound.addSubview(stackControlSound)
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				stackControlSound.topAnchor.constraint(equalTo: viewControlsSound.topAnchor),
				stackControlSound.bottomAnchor.constraint(equalTo: viewControlsSound.bottomAnchor),
				stackControlSound.leadingAnchor.constraint(equalTo: viewControlsSound.safeAreaLayoutGuide.leadingAnchor, constant: 10),
				stackControlSound.trailingAnchor.constraint(equalTo: viewControlsSound.safeAreaLayoutGuide.trailingAnchor, constant: -10),
				stackControlSound.heightAnchor.constraint(equalToConstant: 28),
				downloadMusic.widthAnchor.constraint(equalToConstant: 28)
				])
		} else {
			NSLayoutConstraint.activate([
				stackControlSound.topAnchor.constraint(equalTo: viewControlsSound.topAnchor, constant: 4),
				stackControlSound.bottomAnchor.constraint(equalTo: viewControlsSound.bottomAnchor),
				stackControlSound.leadingAnchor.constraint(equalTo: viewControlsSound.leadingAnchor, constant: 10),
				stackControlSound.trailingAnchor.constraint(equalTo: viewControlsSound.trailingAnchor, constant: -10),
				stackControlSound.heightAnchor.constraint(equalToConstant: 28),
				downloadMusic.widthAnchor.constraint(equalToConstant: 28)
				])
		}
		
		stackTrackSound = UIStackView(arrangedSubviews: [progressView, musicPlayerLabel])
		stackTrackSound.translatesAutoresizingMaskIntoConstraints = false
		stackTrackSound.spacing = 5
		stackTrackSound.distribution = .fill
		stackTrackSound.alignment = .fill
		stackTrackSound.axis = .horizontal
		view.addSubview(stackTrackSound)
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				stackTrackSound.topAnchor.constraint(equalTo: view.topAnchor, constant: 103),
				stackTrackSound.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
				stackTrackSound.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
				stackTrackSound.heightAnchor.constraint(equalToConstant: 10)
				])
		} else {
			NSLayoutConstraint.activate([
				stackTrackSound.topAnchor.constraint(equalTo: view.topAnchor, constant: 103),
				stackTrackSound.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
				stackTrackSound.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
				stackTrackSound.heightAnchor.constraint(equalToConstant: 10)
				])
		}
		musicPlayerLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
		
		view.addSubview(viewWebView)
		viewWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
		viewWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
		viewWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
		viewWebView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
		
		viewWebView.addSubview(myWebView)
		if #available(iOS 11.0, *) {
			myWebView.leadingAnchor.constraint(equalTo: viewWebView.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
			myWebView.trailingAnchor.constraint(equalTo: viewWebView.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
			myWebView.bottomAnchor.constraint(equalTo: viewWebView.bottomAnchor, constant: 0).isActive = true
			myWebView.topAnchor.constraint(equalTo: viewWebView.topAnchor).isActive = true
		} else {
			myWebView.leadingAnchor.constraint(equalTo: viewWebView.leadingAnchor, constant: 0).isActive = true
			myWebView.trailingAnchor.constraint(equalTo: viewWebView.trailingAnchor, constant: 0).isActive = true
			myWebView.bottomAnchor.constraint(equalTo: viewWebView.bottomAnchor, constant: 0).isActive = true
			myWebView.topAnchor.constraint(equalTo: viewWebView.topAnchor).isActive = true
		}
		
		allStackViewAreasLayout = UIStackView(arrangedSubviews: [viewTipoFonte, viewSlider, viewControlsSound, stackTrackSound])
		allStackViewAreasLayout.translatesAutoresizingMaskIntoConstraints = false
		allStackViewAreasLayout.spacing = 0
		allStackViewAreasLayout.distribution = .fill
		allStackViewAreasLayout.alignment = .fill
		allStackViewAreasLayout.axis = .vertical
		view.addSubview(allStackViewAreasLayout)
		
		NSLayoutConstraint.activate([
			allStackViewAreasLayout.leftAnchor.constraint(equalTo: view.leftAnchor),
			allStackViewAreasLayout.rightAnchor.constraint(equalTo: view.rightAnchor),
			allStackViewAreasLayout.topAnchor.constraint(equalTo: view.topAnchor)
			])
		
	}
	
	@objc private func handleControlsPainel() {
		if allStackViewAreasLayout.isHidden {
			animateView(view: allStackViewAreasLayout, toHidden: false)
			buttomControlPainel.tintColor = UIColor.verdeTitulo
			
		} else {
			animateView(view: allStackViewAreasLayout, toHidden: true)
			buttomControlPainel.tintColor = UIColor.lightBlue
		}
	}
	
	// MARK: - UIScrollViewDelegate Methods
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		navigationController?.hidesBarsOnSwipe = true
	}
	
	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		navigationController?.setNavigationBarHidden(hidesBottomBarWhenPushed, animated: true)
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
	
	//Faz download da imagem no src do HTML para o celular
	func downloadImagemWebView() {
		//Verifica se Há Valor no Slider
		if currentValueSlider == 0 {
			print("DEFINIDO TAMANHO PADRÃO DA FONTE")
			currentValueSlider = 8
		} else {
			print("DEFINIDO TAMANHO DE \(currentValueSlider) DA FONTE")
		}
		
		let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
		// create a name for your image
		let fileURL = documentsDirectoryURL.appendingPathComponent("001.jpg)")
		
		if !FileManager.default.fileExists(atPath: fileURL.path) {
			
			print("file no exists \(fileURL.path)")
			
			
			var quantidadeEstrofe = 0
			
			if hinariosFavDetail.estrofeUmFav == "nil" {
				quantidadeEstrofe = 0
			} else if hinariosFavDetail.estrofeDoisFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav == "nil" {
				quantidadeEstrofe = 1 //-----começa aqui-------------------------------------------------------------------------------------
			} else if hinariosFavDetail.estrofeDoisFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 12
			} else if hinariosFavDetail.estrofeDoisFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 13
			} else if hinariosFavDetail.estrofeTresFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav == "nil" {
				quantidadeEstrofe = 2 //-----começa aqui-------------------------------------------------------------------------------------
			} else if hinariosFavDetail.estrofeTresFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 10
			} else if hinariosFavDetail.estrofeTresFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 11
			} else if hinariosFavDetail.estrofeQuatroFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav == "nil" {
				quantidadeEstrofe = 3 //-----começa aqui-------------------------------------------------------------------------------------
			} else if hinariosFavDetail.estrofeQuatroFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 6
			} else if hinariosFavDetail.estrofeQuatroFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 7
			} else if hinariosFavDetail.estrofeCincoFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav == "nil" {
				quantidadeEstrofe = 4 //-----começa aqui-------------------------------------------------------------------------------------
			} else if hinariosFavDetail.estrofeCincoFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 8
			} else if hinariosFavDetail.estrofeCincoFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 9
			} else if hinariosFavDetail.estrofeCincoFav != "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 14
			} else if hinariosFavDetail.estrofeCincoFav != "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 15
			} else {
				quantidadeEstrofe = 5
			}
			
			switch (quantidadeEstrofe) {
			case 1...1:
				print("UMA ESTROFE APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...2:
				print("DUAS ESTROFES APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...3:
				print("TRES ESTROFES APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
				
			case 1...4:
				print("QUATRO ESTROFES APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...5:
				print("CINCO ESTROFE APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"estrofe-quin\"><h3>5ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeCincoFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...6:
				print("3 ESTROFES --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...7:
				print("3 ESTROFES --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...8:
				print("4 ESTROFES --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...9:
				print("4 ESTROFES --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...10:
				print("2 ESTROFES --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...11:
				print("2 ESTROFES --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...12:
				print("1 ESTROFE --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...13:
				print("1 ESTROFE --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...14:
				print("5 ESTROFES --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-quin\"><h3>5ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeCincoFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...15:
				print("5 ESTROFES --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-quin\"><h3>5ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeCincoFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			default:
				print("APENAS CORO INCICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src=\"semImagem.jpg\"/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			}
			
		} else {
			
			print("file already exists")
			
			var quantidadeEstrofe = 0
			
			if hinariosFavDetail.estrofeUmFav == "nil" {
				quantidadeEstrofe = 0
			} else if hinariosFavDetail.estrofeDoisFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav == "nil" {
				quantidadeEstrofe = 1 //-----começa aqui-------------------------------------------------------------------------------------
			} else if hinariosFavDetail.estrofeDoisFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 12
			} else if hinariosFavDetail.estrofeDoisFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 13
			} else if hinariosFavDetail.estrofeTresFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav == "nil" {
				quantidadeEstrofe = 2 //-----começa aqui-------------------------------------------------------------------------------------
			} else if hinariosFavDetail.estrofeTresFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 10
			} else if hinariosFavDetail.estrofeTresFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 11
			} else if hinariosFavDetail.estrofeQuatroFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav == "nil" {
				quantidadeEstrofe = 3 //-----começa aqui-------------------------------------------------------------------------------------
			} else if hinariosFavDetail.estrofeQuatroFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 6
			} else if hinariosFavDetail.estrofeQuatroFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 7
			} else if hinariosFavDetail.estrofeCincoFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav == "nil" {
				quantidadeEstrofe = 4 //-----começa aqui-------------------------------------------------------------------------------------
			} else if hinariosFavDetail.estrofeCincoFav == "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 8
			} else if hinariosFavDetail.estrofeCincoFav == "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 9
			} else if hinariosFavDetail.estrofeCincoFav != "nil" && hinariosFavDetail.estrofeCoroNormalFav != "nil" {
				quantidadeEstrofe = 14
			} else if hinariosFavDetail.estrofeCincoFav != "nil" && hinariosFavDetail.estrofeCoroInicioFav != "nil" {
				quantidadeEstrofe = 15
			} else {
				quantidadeEstrofe = 5
			}
			
			switch (quantidadeEstrofe) {
			case 1...1:
				print("UMA ESTROFE APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...2:
				print("DUAS ESTROFES APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...3:
				print("TRES ESTROFES APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"></head><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
				
			case 1...4:
				print("QUATRO ESTROFES APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...5:
				print("CINCO ESTROFE APENAS")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"estrofe-quin\"><h3>5ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeCincoFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...6:
				print("3 ESTROFES --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...7:
				print("3 ESTROFES --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...8:
				print("4 ESTROFES --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...9:
				print("4 ESTROFES --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...10:
				print("2 ESTROFES --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...11:
				print("2 ESTROFES --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...12:
				print("1 ESTROFE --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...13:
				print("1 ESTROFE --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...14:
				print("5 ESTROFES --- CORO NORMAL")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div><div id=\"estrofe-quin\"><h3>5ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeCincoFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroNormalFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			case 1...15:
				print("5 ESTROFES --- CORO INICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-prim\"><h3>1ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeUmFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-segun\"><h3>2ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeDoisFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-terc\"><h3>3ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeTresFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-quart\"><h3>4ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeQuatroFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div><div id=\"estrofe-quin\"><h3>5ª Estrofe</h3><p class=\"content\">\(hinariosFavDetail.estrofeCincoFav)</p></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			default:
				print("APENAS CORO INCICIO")
				
				let html = "<!doctype html><head><meta charset=\"UTF-8\"><title>Hinário Adventista do 7º Dia</title><link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\"><body style=\"font-size:\(currentValueSlider)vw;font-family:\(currentValueFont);background-color:\(currentColorBack);\"><div class=\"container clearfix\"><div id=\"imagem-topo\" style=\"outline:none;\"><img class=\"img-class\" src='\(fileURL.path)'/><h1 class=\"heading\">\(hinariosFavDetail.numberFav + " - " + hinariosFavDetail.nameFav)</h1><h4 class=\"authing\">\(hinariosFavDetail.authFav)</h4></div><div id=\"coro\"><h3>Coro</h3><p class=\"content\">\(hinariosFavDetail.estrofeCoroInicioFav)</p></div></div><br/></body></html>"
				
				let mainbundle = Bundle.main.bundlePath
				let bundleURL = NSURL(fileURLWithPath: mainbundle)
				self.myWebView.loadHTMLString(html, baseURL: bundleURL as URL)
			}
		}
	}
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
