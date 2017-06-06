//
//  NetworkProvider.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 19.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Alamofire
import Mapper

struct NetworkProvider {

    static let shared = NetworkProvider()
    
    let alamofireManager: SessionManager

    private enum Constants {
        static let timeout: TimeInterval = 10.0
        static let perPage = "per_page"
        static let page = "page"
        static let events = "events"
        static let event = "event"
        static let speakers = "speakers"
    }

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = Constants.timeout
        configuration.timeoutIntervalForRequest = Constants.timeout
        
        alamofireManager = SessionManager(configuration: configuration)
    }

    @discardableResult func eventsList(with page: Int, perPage: Int = 5, completionHandler: @escaping (NetworkResponse<NetworkPage<Event>>) -> ()) -> DataRequest {
        let request = alamofireManager.request(NetworkRouter.eventsList([Constants.perPage: perPage, Constants.page: page]))
        request.responseJSON { response in
            response.result.responsePage(for: Constants.events, completionHandler: completionHandler)
        }

        return request
    }

    @discardableResult func speakersList(with page: Int, perPage: Int, completionHandler: @escaping (NetworkResponse<NetworkPage<Speaker>>) -> ()) -> DataRequest {
        let request = alamofireManager.request(NetworkRouter.speakersList([Constants.perPage: perPage, Constants.page: page]))
        request.responseJSON { response in
            response.result.responsePage(for: Constants.speakers, completionHandler: completionHandler)
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
}
