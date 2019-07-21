//
//  HinarioItem.swift
//  Hinário
//
//  Created by Ewerson Castelo on 06/01/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import Foundation
import Firebase

struct ExpansableNames {
//	var isExpanded: Bool
	var hinos: [FavoritableHinos]
}

struct FavoritableHinos {
	let name: String
	let number: String
	let groups: String
	var hasFavorited: Bool
	let compositor: String
	let image: String
	let imageURL: String
	let music: String
	let musicURL: String
	let estrofeUm: String
	let estrofeDois: String
	let estrofeTres: String
	let estrofeQuatro: String
	let estrofeCinco: String
	let estrofeCoroNormal: String
	let estrofeCoroInicio: String
	let ref: DatabaseReference!
}
