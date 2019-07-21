//
//  HinosController+UITableView.swift
//  Hinário
//
//  Created by Ewerson Castelo on 18/05/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import UIKit

extension HinosController {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltering() {
			return filteredCandies.count
		}
		return favoritableHinos.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HinosCell
		
		let hino: Hinario
		if isFiltering() {
			hino = filteredCandies[indexPath.row]
		} else {
			hino = favoritableHinos[indexPath.row]
		}
		
		cell.companyTest = hino
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let shareAction = UITableViewRowAction(style: .default, title: "Compartilhar") { (rowAction, indexPath) in
			print("Share Action")
			
			let defaultText = "''" + self.favoritableHinos[indexPath.row].number + "-" + self.favoritableHinos[indexPath.row].name + "''. É meu hino favorito! Baixe agora o Novo App Hinário Adventista: https://goo.gl/ET4UcB #Hinario7Dia"
			let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
			self.present(activityController, animated: true, completion: nil)
		}
		
		shareAction.backgroundColor = UIColor.tituloDois
		
		return [shareAction]
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let hinosDetailConstroller = HinosDetailController()
		
		if let indexPath = tableView.indexPathForSelectedRow {
			if searchController.isActive && searchController.searchBar.text != "" {
				hinosDetailConstroller.hinarios = filteredCandies[indexPath.row]
				
			} else {
				hinosDetailConstroller.hinarios = favoritableHinos[indexPath.row]
				
				let musics = favoritableHinos[indexPath.row]
				print("URL Da Musica não Criada")
				let musicRef = storage.child("music/\(musics.music)")
				musicRef.downloadURL { (URLmusic, error) in
					if (error != nil) {
						print("HOUVE ALGUM ERRO AO GERAR A URL \(String(describing: error?.localizedDescription))")
					} else {

						print("A MUSICA \(musicRef) GEROU A URL: \(URLmusic!)")

						//Salva endereço local com o arquivo
						let hinarioItem = self.favoritableHinos[indexPath.row]
						let toggleUrlMusic = "\(URLmusic!)"
						hinarioItem.ref?.updateChildValues([
							"musicURL" : toggleUrlMusic
							])
					}
				}
			}
		}
		
		//Deixa o Botão Voltar sem Título
		let backItem = UIBarButtonItem()
		backItem.title = "Voltar"
		navigationItem.backBarButtonItem = backItem
		
		if #available(iOS 11.0, *) {
			
		} else {
			//Fix bug Search Controller iOS 9.3
			searchController.isActive = false
		}
		
		navigationController?.pushViewController(hinosDetailConstroller, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	
	
}
