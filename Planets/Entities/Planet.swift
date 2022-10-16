//
//  Planet.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

struct Planet: Decodable {
	let name: String
	let rotation_period: String
	let orbital_period: String
	let diameter: String
	let climate: String
	let gravity: String
	let terrain: String
	let url: String
}

