//
//  MockResultsProvider.swift
//  PlanetsTests
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation
@testable import Planets


struct MockResultsProvider: PlanetService {
	private let client: NetworkClient
	
	func fetchPlanetList(pageNumber: Int, completionHandler: @escaping (Result<PlanetListResponse, AppError>) -> Void) {
		PlanetListEndpoint(pageNumber: 1).fetchData(completionHandler)
	}
	
	init() {
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		client = NetworkClient(session: URLSession(configuration: config))
	}
}
