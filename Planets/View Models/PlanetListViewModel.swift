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
	let managedContext = CoreDataStackManager.shared.coreDataStack.managedContext
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
		for planet in planets {
			let planetEntity = PlanetEntity(context: managedContext)
			planetEntity.setValue(planet.url, forKey: #keyPath(PlanetEntity.planetUrl))
			planetEntity.setValue(planet.name, forKey: #keyPath(PlanetEntity.planetName))
			CoreDataStackManager.shared.coreDataStack.saveContext()
		}
	}

	private func handleError(_ error: AppError) {
		guard case AppError.noInternet = error else {
			delegate?.handle(error: error)
			return
		}

		do {
			let planetsFetch: NSFetchRequest<PlanetEntity> = PlanetEntity.fetchRequest()
			let results = try managedContext.fetch(planetsFetch)
			guard results.count > 0 else {
				delegate?.handle(error: error)
				return
			}
			planets = results.compactMap({
				PlanetCellModel(from: $0)
			})
			delegate?.planetListUpdated()
		} catch let error as NSError {
			print("Fetch error: \(error) description: \(error.userInfo)")
			delegate?.handle(error: error)
		}
	}
}
