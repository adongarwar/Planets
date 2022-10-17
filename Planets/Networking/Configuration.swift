//
//  Configuration.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

enum Method: String {
	case get = "Get"
	case post = "POST"
}

// Form request url and apply queries or post body to the requests.
struct Configuration {
	let method: Method
	let url: URL
	
	init(method: Method = .get,
		 base: URL,
		 path: String,
		 queryParams: [String: String] = [:]) {
		self.method = method
		let queryItems = queryParams.map({URLQueryItem(name: $0.key, value: $0.value)})
		
		if #available(iOS 16.0, *) {
			var url = base.appendingPathComponent(path)
			url.append(queryItems: queryItems)
			self.url = url
		} else {
			var urlComps = URLComponents(url: base, resolvingAgainstBaseURL: false)!
			urlComps.path = path
			urlComps.queryItems = queryItems
			self.url = urlComps.url!
		}
	}
}
