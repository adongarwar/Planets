//
//  Planet.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

struct Planet: Decodable {
	let name: String
	let rotationPeriod: String
	let orbitalPeriod: String
	let diameter: String
	let climate: String
	let gravity: String
	let terrain: String
	let url: String

	private enum CodingKeys: String, CodingKey {
		case name, rotationPeriod = "rotation_period",
			 orbitalPeriod = "orbital_period", diameter,
			 climate, gravity, terrain, url
	}
}
