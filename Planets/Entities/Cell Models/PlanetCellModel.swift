//
//  PlanetCellModel.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

struct PlanetCellModel {
	let name: String
	
	init(from planet: Planet) {
		self.name = planet.name
	}
}
