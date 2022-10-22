//
//  NetworkClient.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

struct NetworkClient {

	private let session: URLSession
	static let shared = NetworkClient(session: URLSession.shared)

	init(session: URLSession) {
		self.session = session
	}

	// Makes endpoint requests using URLSession APIs.
	//
	// URL formation with query params and post body has to be handles by Configuration instances
	//
	// - Parameter urlRequest: URLRequest instance
	// - Parameter onMainThread: If response to be returned on main thread.
	// - Parameter completion: Bloack base return api.
	func request(with urlRequest: URLRequest, _ onMainThread: Bool = true,
				_ completion: @escaping (Result<Data, Error>) -> Void) {

		session.dataTask(with: urlRequest) { (data, _, error) in
			switch onMainThread {
			case true:
				DispatchQueue.main.async {
					execute(data, error, completion)
				}
			case false:
				execute(data, error, completion)
			}
		}.resume()
	}

	private func execute(_ data: Data?, _ error: Error?,
				   _ completion: @escaping (Result<Data, Error>) -> Void) {
		guard let data = data else {
			completion(.failure(error ?? AppError.unknown(nil)))
			return
		}
		completion(.success(data))
	}
}
