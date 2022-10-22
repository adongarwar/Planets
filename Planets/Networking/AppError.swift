//
//  AppError.swift
//  Planets
//
//  Created by Avinash Dongarwar on 10/15/22.
//

import Foundation

public enum AppError: Error, CustomStringConvertible {
	case keyMappingFailure(message: String?)
	case noInternet
	case timedOut
	case networkError(Error)
	case invalidEndpoint(String)
	case unknown(Error?)

	public var description: String {
		switch self {
		case .keyMappingFailure(let message):
			return "Json decoding error - \(String(describing: message)))"
		case .noInternet:
			return "No internet connection"
		case .timedOut:
			return "Connection timed out"
		case .networkError(let code):
			return "Network error with code \(code)"
		case .unknown(let error):
			let description = error?.localizedDescription ?? "Underlying error not available."
			return "Unknown error - \(description)"
		case .invalidEndpoint(let urlString):
			return "Invalid endpint - \(urlString)"
		}
	}
}

extension Error {
	var appError: AppError {
		if let decoderError = self as? DecodingError {
			switch decoderError {
			case .typeMismatch(_, let error), .valueNotFound(_, let error),
						.keyNotFound(_, let error), .dataCorrupted(let error):
					return .keyMappingFailure(message: error.debugDescription)
			default:
					return .unknown(self)
			}
		} else if (self as? URLError)?.code == URLError.Code.notConnectedToInternet {
			return .noInternet
		} else if (self as? URLError)?.code ==  URLError.Code.timedOut {
			return .timedOut
		} else if self is URLError {
			return .networkError(self)
		} else {
			return .unknown(self)
		}
	}
}
