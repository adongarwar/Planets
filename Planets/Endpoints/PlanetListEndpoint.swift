//
//  PlanetListEndpoint.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

// Holds endpoint details like base url etc. to make server requests.
struct PlanetListEndpoint: Endpoint {
	typealias ResponseType = PlanetListResponse
	let configuration: Configuration
	let urlString = "https://swapi.dev/api"
	
	init(pageNumber: Int) {
		configuration = Configuration(base: URL(string: urlString)!,
									  path: "/planets/",
									  queryParams: ["page": String(pageNumber)])
	}
}
