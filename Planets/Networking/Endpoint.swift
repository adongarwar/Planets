//
//  Endpoint.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

protocol Endpoint {
	associatedtype ResponseType: Decodable
	var configuration: Configuration { get }
}

extension Endpoint {
		
	func fetchData(using client: NetworkClient = NetworkClient.shared, on mainThread: Bool = true,
						  _ completionHandler: @escaping (Result<ResponseType, AppError>) -> Void) {
		var urlRequest = URLRequest(url: configuration.url)
		urlRequest.httpMethod = configuration.method.rawValue
		
		client.request(with: urlRequest) { result in
			switch result {
				case .success(let data):
					do {
						let result = try JSONDecoder().decode(ResponseType.self, from: data)
						completionHandler(.success(result))
					} catch {
						completionHandler(.failure(error.appError))
					}
				case .failure(let error):
					completionHandler(.failure(error.appError))
			}
		}
	}
}
