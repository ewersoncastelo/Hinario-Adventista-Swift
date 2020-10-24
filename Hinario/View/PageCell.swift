//
//  PageCell.swift
//  Hinário
//
//  Created by Ewerson Castelo on 10/03/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import UIKit
import SnapKit

class PageCell: UICollectionViewCell {
	
	var page: Page? {
		didSet {
			guard let page = page else { return }
			
			imageView.image = UIImage(named: page.imageName)
			
			let color = UIColor(white: 0.6, alpha: 1)
			
			let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: color])
			
			attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: color]))
			
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .center
			
			let lenght = attributedText.string.count
			attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: lenght))
			
			textView.attributedText = attributedText
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	let imageView: UIImageView = {
		let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
		iv.backgroundColor = .yellow
		iv.image = UIImage(named: "page1")
		iv.clipsToBounds = true
		return iv
	}()
	
	let textView: UITextView = {
		let tv = UITextView()
		tv.text = "SAMPLE TEXT"
		tv.isEditable = false
		tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		return tv
	}()
	
	let lineSeparatorView: UIView = {
	  	let view = UIView()
		view.backgroundColor = UIColor(white: 0.9, alpha: 1)
		return view
	}()
	
	func setupViews(){
		addSubview(imageView)
		addSubview(textView)
		addSubview(lineSeparatorView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).inset(-10)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(textView.snp.top)
        }
		
        textView.snp.makeConstraints { make in
            make.left.equalTo(snp.left).inset(20)
            make.right.equalTo(snp.right).inset(20)
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(snp.height).multipliedBy(0.3)
        }
        
        lineSeparatorView.snp.makeConstraints { make in
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(textView.snp.top)
            make.height.equalTo(1)
        }
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	
	
	
	
	
	
	
}
