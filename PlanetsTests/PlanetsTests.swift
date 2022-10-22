//
//  PlanetsTests.swift
//  PlanetsTests
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import XCTest
@testable import Planets

class PlanetsTests: XCTestCase {
	lazy var client: NetworkClient = {
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLProtocol.self]

		return NetworkClient(session: URLSession(configuration: config))
	}()

	func testPlanets() {
		let expectation = expectation(description: "New Books API expectation")

		PlanetListEndpoint(pageNumber: 1).fetchData(using: client) { (result) in
			switch result {
			case .success(let response):
				XCTAssertEqual(response.count, 60)
				XCTAssertEqual(response.next, "https://swapi.dev/api/planets/?page=2")
				XCTAssertNil(response.previous)
				XCTAssertEqual(response.results.count, 10)

				let planet = response.results[0]
				XCTAssertEqual(planet.name, "Tatooine")
				XCTAssertEqual(planet.rotation_period, "23")
				expectation.fulfill()
			case .failure:
				()
			}
		}

		wait(for: [expectation], timeout: 10.5)
	}
}
