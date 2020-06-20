//
//  HinosCell.swift
//  Hinário
//
//  Created by Ewerson Castelo on 07/01/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import UIKit

class HinosCell: UITableViewCell {
	
	var companyTest: Hinario? {
        didSet {
            nameHino.text = companyTest?.name
            numberHino.text = companyTest?.number
            authHino.text = companyTest?.compositor
        }
	}
	
	let imageHino: UIImageView = {
		let imageView = UIImageView()
		//This enable AutoLayout for Item
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.alpha = 0.800000011920929
		imageView.layer.borderWidth = 0.2
		imageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor
		imageView.layer.masksToBounds = true
		//Define an imagem like circle
		imageView.layer.cornerRadius = 30
		imageView.clipsToBounds = true
		return imageView
	}()
	
	let nameHino: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .tituloUm
		label.font = UIFont.preferredFont(forTextStyle: .headline)
		label.lineBreakMode = NSLineBreakMode.byTruncatingTail
		label.numberOfLines = 0
		return label
	}()
	
	let numberHino: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .tituloDois
		label.font = UIFont.preferredFont(forTextStyle: .subheadline)
		return label
	}()
	
	let authHino: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .tituloTres
		label.font = UIFont.preferredFont(forTextStyle: .footnote)
		return label
	}()
	
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		 super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	func setupViews() {
		
		let itemCellStackView = UIStackView(arrangedSubviews: [nameHino, numberHino, authHino])
		itemCellStackView.translatesAutoresizingMaskIntoConstraints = false
		itemCellStackView.distribution = .fill
		itemCellStackView.axis = .vertical
		itemCellStackView.alignment = .fill
		itemCellStackView.spacing = 1
		addSubview(itemCellStackView)
		
		//Constraints StackView Name, Number Auth
		itemCellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1).isActive = true
		itemCellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
		itemCellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true
		itemCellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1).isActive = true
		
		let allItemsCellStackView = UIStackView(arrangedSubviews: [itemCellStackView])
		allItemsCellStackView.translatesAutoresizingMaskIntoConstraints = false
		allItemsCellStackView.distribution = .fill
		allItemsCellStackView.axis = .horizontal
		allItemsCellStackView.alignment = .center
		allItemsCellStackView.spacing = 5
		addSubview(allItemsCellStackView)
		
		//Constraints StackViewItem and Image
		if #available(iOS 11.0, *) {
			allItemsCellStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
			allItemsCellStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
			allItemsCellStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 1).isActive = true
			allItemsCellStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 10).isActive = true
		} else {
			allItemsCellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
			allItemsCellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
			allItemsCellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true
			allItemsCellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
		}
	
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
