//
//  PlanetListService.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

protocol PlanetService {
	func fetchPlanetList(pageNumber: Int, completionHandler: @escaping (Result<PlanetListResponse, AppError>) -> Void)
}

struct PlanetListService: PlanetService {
	func fetchPlanetList(pageNumber: Int, completionHandler: @escaping (Result<PlanetListResponse, AppError>) -> Void) {
		PlanetListEndpoint(pageNumber: pageNumber).fetchData(completionHandler)
	}
}
