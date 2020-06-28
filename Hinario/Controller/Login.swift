 //
//  Login.swift
//  Hinário
//
//  Created by Ewerson Castelo on 09/03/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import UIKit

class Login: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.dataSource = self
		cv.delegate = self
		cv.backgroundColor = .black
        cv.tintColor = .green
		cv.isPagingEnabled = true
		return cv
	}()
	
	let cellId = "cellId"
	let loginCellId = "loginCellId"
	
	let pages: [Page] = {
		let firstPage = Page(title: "Tenha o Hinário Seven Day em Suas Mãos", message: "Utilize-o em qualquer lugar, baixe os hinos e ouça eles off-line.", imageName: "page1")
		
		let secondPage = Page(title: "Pesquise pelo nome ou número do hino", message: "Arraste para baixo para exibir o campo de busca, então, basta selecionar sua forma preferida de pesquisa, por: \"Nome\" ou \"Número\".", imageName: "page2")
		
		let thirdPage = Page(title: "Marque seus hinos preferidos", message: "Marque o ícone de estrela na barra de navegação e pronto. Seus hinos favoritos estarão disponíveis na seção \"Favoritos\" na página de inínio.", imageName: "page3")
		
		let fourthPage = Page(title: "Ouça os hinos cantados e baixe-os para ouvir off-line", message: "Você pode usar sua conexão de internet para ouvir os hinos ou clicar no ícone baixar, para ouvir off-line.", imageName: "page4")
		
		return [firstPage, secondPage, thirdPage, fourthPage]
	}()
	
	lazy var pageControl: UIPageControl = {
		let pc = UIPageControl()
		pc.pageIndicatorTintColor = .darkGray
		pc.currentPageIndicatorTintColor = .verdeTitulo
		pc.numberOfPages = pages.count + 1
		return pc
	}()
	
	let skipButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Pular", for: .normal)
		button.setTitleColor(.orange, for: .normal)
		button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
		return button
	}()
	
	lazy var nextButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Próximo", for: .normal)
		button.setTitleColor(.orange, for: .normal)
		button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
		return button
	}()
	
	var pageControlBottomAnchor: NSLayoutConstraint?
	var skipButtonBottomAnchor: NSLayoutConstraint?
	var nextButtonBottomAnchor: NSLayoutConstraint?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(collectionView)
		view.addSubview(pageControl)
		view.addSubview(skipButton)
		view.addSubview(nextButton)
		
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
		skipButtonBottomAnchor = skipButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50)[1]
		nextButtonBottomAnchor = nextButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 50)[0]

		
		registerCells()
	}
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		
		let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
		pageControl.currentPage = pageNumber
		
		if pageNumber == pages.count {
			pageControlBottomAnchor?.constant = 60
			skipButtonBottomAnchor?.constant = 70
			nextButtonBottomAnchor?.constant = 70
		} else {
			pageControlBottomAnchor?.constant = 0
			skipButtonBottomAnchor?.constant = 0
			nextButtonBottomAnchor?.constant = 0
		}
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
		
		goToLoginScreen()
	}
	
	@objc func handleSkip() {
		//Present the main view
		let hinoPageLogin = InicioLogin()
        hinoPageLogin.modalPresentationStyle = .fullScreen
		self.present(hinoPageLogin, animated: true, completion: nil)
	}
	
	@objc func handleNext() {
		
		if pageControl.currentPage == pages.count {
			return
		}
		
		let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
		collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		pageControl.currentPage += 1
		
		goToLoginScreen()

	}
	
	fileprivate func registerCells() {
		collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: loginCellId)
	}
	
	func goToLoginScreen() {
		if pageControl.currentPage == 4 {
			let hinoPageLogin = InicioLogin()
            // force presentation in fullscreen mode
            hinoPageLogin.modalPresentationStyle = .fullScreen
			self.present(hinoPageLogin, animated: true, completion: nil)
			
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pages.count + 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.item == pages.count {
			let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath)
			
			return loginCell
		}
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
		
		let page = pages[indexPath.item]
		cell.page = page
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: view.frame.height)
	}
	
	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		
		collectionView.collectionViewLayout.invalidateLayout()
		
		let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
		
		DispatchQueue.main.async {
			self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		}
	}

}












