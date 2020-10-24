 //
//  Login.swift
//  Hinário
//
//  Created by Ewerson Castelo on 09/03/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import UIKit
import SnapKit

class Walkthrough: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
    // MARK:- Variables
    
    lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.dataSource = self
		cv.delegate = self
        cv.tintColor = .green
		cv.isPagingEnabled = true
        cv.backgroundColor = .white
		return cv
	}()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .darkGray
        pc.currentPageIndicatorTintColor = .verdeTitulo
        pc.backgroundColor = .black
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
	
	let cellId = "cellId"
	let loginCellId = "loginCellId"
	
	let pages: [Page] = {
		let firstPage = Page(title: "Tenha o Hinário Seven Day em Suas Mãos", message: "Utilize-o em qualquer lugar, baixe os hinos e ouça eles off-line.", imageName: "page1")
		
		let secondPage = Page(title: "Pesquise pelo nome ou número do hino", message: "Arraste para baixo para exibir o campo de busca, então, basta selecionar sua forma preferida de pesquisa, por: \"Nome\" ou \"Número\".", imageName: "page2")
		
		let thirdPage = Page(title: "Marque seus hinos preferidos", message: "Marque o ícone de estrela na barra de navegação e pronto. Seus hinos favoritos estarão disponíveis na seção \"Favoritos\" na página de inínio.", imageName: "page3")
		
		let fourthPage = Page(title: "Ouça os hinos cantados e baixe-os para ouvir off-line", message: "Você pode usar sua conexão de internet para ouvir os hinos ou clicar no ícone baixar, para ouvir off-line.", imageName: "page4")
		
		return [firstPage, secondPage, thirdPage, fourthPage]
	}()
	
	// MARK:- LIFE CYCLE

    override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(collectionView)
		view.addSubview(pageControl)
		view.addSubview(skipButton)
		view.addSubview(nextButton)
		
        setupUI()
		
		registerCells()
	}
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
	
    // MARK:- FUNCTIONS
    
    fileprivate func setupUI() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        pageControl.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(40)
        }
        
        skipButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).inset(15)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(50)
            make.width.equalTo(60)
        }
        
        nextButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).inset(15)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(50)
            make.width.equalTo(60)
        }
    }
    
    // If dark mode active collection view must be black background
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if traitCollection.userInterfaceStyle == .dark {
                    collectionView.backgroundColor = .black
                }
                else {
                    collectionView.backgroundColor = .white
                }
            }
        } else {
            collectionView.backgroundColor = .white
        }
    }
    
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		
		let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
		pageControl.currentPage = pageNumber
		
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

}
