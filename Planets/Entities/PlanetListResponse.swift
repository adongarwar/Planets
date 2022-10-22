//
//  PlanetListResponse.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

struct PlanetListResponse: Decodable {
	let count: Int
	let next: String?
	let previous: String?
	let results: [Planet]
}
