//
//  NetworkRouter.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Alamofire

enum NetworkRouter: URLRequestConvertible {

    private enum Constants {
        static let basePath = "http://92.222.84.21:8080/api/"
        static let version = "v1"
    }

    // MARK: Event
    case eventsList(Parameters)
    case eventDetails(Int)

    // MARK: Speakres
    case speakersList(Parameters)


    var method: HTTPMethod {
        switch self {
        case .eventsList,
             .eventDetails,
             .speakersList:
            return .get
        }
    }

    var path: String {
        switch self {
        case .eventsList:
            return "/events"
        case .eventDetails(let id):
            return "/events/\(id)"
        case .speakersList:
            return "/speakers"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try (Constants.basePath + Constants.version).asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .eventsList(let params):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .eventDetails:
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: nil)
        case .speakersList(let params):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        }
    }
}
