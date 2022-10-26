//
//  PlanetListViewModel.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation
import CoreData

protocol PlanetListViewModelDelegate: AnyObject {
	func planetListUpdated()
	func handle(error: Error)
}

class PlanetListViewModel {

	weak var delegate: PlanetListViewModelDelegate?
	// The datasource to serve Views
	private(set) var planets: [PlanetCellModel] = []
	let service: PlanetService

	// To be used while implementing pagination
	private var page = 1

	init(service: PlanetService) {
		self.service = service
	}

	func fetchPlanetList() {
		// Increment/decrement page here while implementing pagination
		service.fetchPlanetList(pageNumber: page) { [weak self] (result) in
			guard let strongself = self else { return }
			switch result {
			case .success(let result):
				// Create instances of Cell Models from server data.
				let cellModels = result.results.compactMap({
					PlanetCellModel(from: $0)
				})
				strongself.planets.append(contentsOf: cellModels)
				strongself.delegate?.planetListUpdated()
				strongself.saveForOffline(result.results)

			case .failure(let error):
				strongself.handleError(error)
			}
		}
	}

	private func saveForOffline(_ planets: [Planet]) {
		let planetDetails = planets.map({($0.url, $0.name)})
		SavedDataManager.shared.saveData(planetDetails)
	}

	private func handleError(_ error: AppError) {
		guard case AppError.noInternet = error else {
			delegate?.handle(error: error)
			return
		}

		guard let savedPlanets = SavedDataManager.shared.getSavedData() else {
			delegate?.handle(error: error)
			return
		}
		planets = savedPlanets
		delegate?.planetListUpdated()
	}
}
