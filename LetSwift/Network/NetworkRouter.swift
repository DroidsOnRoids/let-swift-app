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
        static let basePath = "/api/"
        static let version = "v1"
    }

    // MARK: Event
    case eventsList(Parameters)
    case eventDetails(Int)

    // MARK: Speakres
    case speakersList(Parameters)
    case speakerDetails(Int)
    case latestSpeakers

    var method: HTTPMethod {
        switch self {
        case .eventsList,
             .eventDetails,
             .speakersList,
             .speakerDetails,
             .latestSpeakers:
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
        case .speakerDetails(let id):
            return "/speakers/\(id)"
        case .latestSpeakers:
            return "/speakers/recent"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = URL.baseServerURL!.appendingPathComponent(Constants.basePath + Constants.version)
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .eventsList(let params), .speakersList(let params):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .eventDetails, .speakerDetails, .latestSpeakers:
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: nil)
        }
    }
}
