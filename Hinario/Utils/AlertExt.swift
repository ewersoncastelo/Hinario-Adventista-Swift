//
//  AlertShowBasic.swift
//  Hinario
//
//  Created by Ewerson Castelo on 21/07/19.
//  Copyright © 2019 Ewerson Castelo. All rights reserved.
//

import Foundation
import UIKit

class AlertExt {
	class func showBasic(title: String, msg: String, vc: UIViewController){
		let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		vc.present(alert, animated: true)
	}
}
