//
//  PlanetListService.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

protocol PlanetService {
	func fetchPlanetList(pageNumber: Int, completionHandler: @escaping (Result<[PlanetCellModel], AppError>) -> Void)
}

struct PlanetListService: PlanetService {
	func fetchPlanetList(pageNumber: Int, completionHandler: @escaping (Result<[PlanetCellModel], AppError>) -> Void) {
		PlanetListEndpoint(pageNumber: pageNumber).fetchData { (result: (Result<PlanetListResponse, AppError>)) in
			switch result {
				case .success(let result):
					let cellModels = result.results.compactMap({
						PlanetCellModel(from: $0)
					})
					completionHandler(.success(cellModels))
					// Save for offline access
					let planetDetails = result.results.map({($0.url, $0.name)})
					SavedDataManager.shared.saveData(planetDetails)
					
				case .failure(let error):
					guard case AppError.noInternet = error else {
						completionHandler(.failure(error))
						return
					}
					
					guard let savedPlanets = SavedDataManager.shared.getSavedData() else {
						completionHandler(.failure(error))
						return
					}
					completionHandler(.success(savedPlanets))
			}
		}
	}
}
