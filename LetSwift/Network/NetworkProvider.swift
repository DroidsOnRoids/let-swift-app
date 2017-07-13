//
//  NetworkProvider.swift
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
import Mapper

struct NetworkProvider {

    static let shared = NetworkProvider()
    static let timeout: TimeInterval = 10.0
    
    let alamofireManager: SessionManager

    private enum Constants {
        static let perPage = "per_page"
        static let page = "page"
        static let events = "events"
        static let event = "event"
        static let speakers = "speakers"
        static let speaker = "speaker"
        static let query = "query"
        static let email = "email"
        static let type = "type"
        static let name = "name"
        static let message = "message"
    }

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = NetworkProvider.timeout
        configuration.timeoutIntervalForRequest = NetworkProvider.timeout
        
        alamofireManager = SessionManager(configuration: configuration)
    }

    @discardableResult func eventsList(with page: Int, perPage: Int = 10, completionHandler: @escaping (NetworkResponse<NetworkPage<Event>>) -> ()) -> DataRequest {
        let request = alamofireManager.request(NetworkRouter.eventsList([Constants.perPage: perPage, Constants.page: page]))
        request.responseJSON { response in
            response.result.responsePage(for: Constants.events, completionHandler: completionHandler)
        }

        return request
    }

    @discardableResult func speakersList(with page: Int, perPage: Int = 5, query: String = "", completionHandler: @escaping (NetworkResponse<NetworkPage<Speaker>>) -> ()) -> DataRequest {
        let params: [String: Any] = [Constants.perPage: perPage,
                                     Constants.page: page,
                                     Constants.query: query]
        let request = alamofireManager.request(NetworkRouter.speakersList(params))
        request.responseJSON { response in
            response.result.responsePage(for: Constants.speakers, completionHandler: completionHandler)
        }

        return request
    }

    @discardableResult func latestSpeakers(completionHandler: @escaping (NetworkResponse<[Speaker]>) -> ()) -> DataRequest {
        let request = alamofireManager.request(NetworkRouter.latestSpeakers)
        request.responseJSON { response in
            response.result.responseArray(for: Constants.speakers, completionHandler: completionHandler)
        }

        return request
    }
    
    @discardableResult func speakerDetails(with id: Int, completionHandler: @escaping (NetworkResponse<Speaker>) -> ()) -> DataRequest {
        let request = alamofireManager.request(NetworkRouter.speakerDetails(id))
        request.responseJSON { response in
            response.result.responseObject(for: Constants.speaker, completionHandler: completionHandler)
        }
        
        return request
    }

    @discardableResult func eventDetails(with id: Int, completionHandler: @escaping (NetworkResponse<Event>) -> ()) -> DataRequest {
        let request = alamofireManager.request(NetworkRouter.eventDetails(id))
        request.responseJSON { response in
            response.result.responseObject(for: Constants.event, completionHandler: completionHandler)
        }

        return request
    }

    @discardableResult func sendContact(with email: String, type: String, name: String, message: String, completionHandler: @escaping (Result<Any>) -> ()) -> DataRequest {
        let params = [Constants.email: email,
                      Constants.type: type,
                      Constants.name: name,
                      Constants.message: message]
        let request = alamofireManager.request(NetworkRouter.contact(params))
        request.responseJSON { response in
            completionHandler(response.result)
        }

        return request
    }
}
