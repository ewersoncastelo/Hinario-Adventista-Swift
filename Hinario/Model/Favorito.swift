//
//  Favoritos.swift
//  Hinário
//
//  Created by Ewerson Castelo on 14/02/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import Foundation
import Firebase

//class Favorito {
//	var nameFav: String
//	var numberFav: String
//	var authFav: String
//	var musicFav: String
//	var musicUrlFav : String
//	var estrofeUmFav: String
//	var estrofeDoisFav: String
//	var estrofeTresFav: String
//	var estrofeQuatroFav: String
//	var estrofeCincoFav: String
//	var estrofeCoroNormalFav: String
//	var estrofeCoroInicioFav: String
//
//	init(nameFav:String, numberFav:String, authFav:String, musicFav:String, musicUrlFav:String, estrofeUmFav: String, estrofeDoisFav: String, estrofeTresFav: String, estrofeQuatroFav: String, estrofeCincoFav: String, estrofeCoroNormalFav: String, estrofeCoroInicioFav: String) {
//		self.nameFav = nameFav
//		self.numberFav = numberFav
//		self.authFav = authFav
//		self.musicFav = musicFav
//		self.musicUrlFav = musicUrlFav
//		self.estrofeUmFav = estrofeUmFav
//		self.estrofeDoisFav = estrofeDoisFav
//		self.estrofeTresFav = estrofeTresFav
//		self.estrofeQuatroFav = estrofeQuatroFav
//		self.estrofeCincoFav = estrofeCincoFav
//		self.estrofeCoroNormalFav = estrofeCoroNormalFav
//		self.estrofeCoroInicioFav = estrofeCoroInicioFav
//	}
//}
import Foundation
import Firebase

struct Favorito {
	let nameFav: String
	let numberFav: String
	let authFav: String
	var musicFav: String
	let musicUrlFav: String
	let estrofeUmFav: String
	let estrofeDoisFav: String
	let estrofeTresFav: String
	let estrofeQuatroFav: String
	let estrofeCincoFav: String
	let estrofeCoroNormalFav: String
	let estrofeCoroInicioFav: String
	let listaRefHino: String //DatabaseReference?
}
