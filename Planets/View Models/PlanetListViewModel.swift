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
				strongself.planets.append(contentsOf: result)
				strongself.delegate?.planetListUpdated()

			case .failure(let error):
				strongself.delegate?.handle(error: error)
			}
		}
	}
}
