//
//  MockURLProtocol.swift
//  PlanetsTests
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

typealias Path = String

class MockURLProtocol: URLProtocol {
	private static let successMock: [Path: Data] = ["/api/planets": MockData.planets]
	private static let failureErrors: [Path: Error] = ["/api/planets":
														NSError(domain: "NetworkingError",
																code: 1111,
																userInfo: nil)]

	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	override func startLoading() {
		if let path = request.url?.path {
			if let mockData = MockURLProtocol.successMock[path] {
				client?.urlProtocol(self, didLoad: mockData)
			} else if let error = MockURLProtocol.failureErrors[path] {
				client?.urlProtocol(self, didFailWithError: error)
			}
		} else {
			client?.urlProtocol(self, didFailWithError: MockSessionError.notSupported)
		}

		client?.urlProtocolDidFinishLoading(self)
	}

	override func stopLoading() {

	}
}

enum MockSessionError: Error {
	case notSupported
}
