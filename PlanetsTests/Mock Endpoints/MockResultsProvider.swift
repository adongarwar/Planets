//
//  MockResultsProvider.swift
//  PlanetsTests
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation
@testable import Planets

struct MockResultsProvider: PlanetService {
	func fetchPlanetList(pageNumber: Int, completionHandler: @escaping (Result<[PlanetCellModel], AppError>) -> Void) {
		PlanetListEndpoint(pageNumber: pageNumber).fetchData { (result: (Result<PlanetListResponse, AppError>)) in
			switch result {
				case .success(let result):
					let cellModels = result.results.compactMap({
						PlanetCellModel(from: $0)
					})
					completionHandler(.success(cellModels))
				case .failure(let error):
					completionHandler(.failure(error))
			}
		}
	}
	
	private let client: NetworkClient

	init() {
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		client = NetworkClient(session: URLSession(configuration: config))
	}
}
