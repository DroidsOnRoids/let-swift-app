//
//  NetworkRouter.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

    // MARK: Contact
    case contact(Parameters)

    var method: HTTPMethod {
        switch self {
        case .eventsList,
             .eventDetails,
             .speakersList,
             .speakerDetails,
             .latestSpeakers:
            return .get
        case .contact:
            return .post
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

        case .contact:
            return "/contact"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = EventBranding.current.apiURL!.appendingPathComponent(Constants.basePath + Constants.version)
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .eventsList(let params), .speakersList(let params):
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: params)
        case .contact(let params):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: params)
        case .eventDetails, .speakerDetails, .latestSpeakers:
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: nil)
        }
    }
}
