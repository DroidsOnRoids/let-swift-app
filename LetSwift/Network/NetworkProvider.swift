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

    private enum Constants {
        static let perPage = "per_page"
        static let page = "page"
        static let events = "events"
        static let event = "event"
        static let speakers = "speakers"
    }

    private init() {}

    @discardableResult func eventsList(with page: Int, perPage: Int, completionHandler: @escaping (NetworkReponse<NetworkPage<Event>>) -> ()) -> DataRequest {
        let request = Alamofire.request(NetworkRouter.eventsList([Constants.perPage: perPage, Constants.page: page]))
        request.responseJSON { response in
            response.result.responsePage(for: Constants.events, completionHandler: completionHandler)
        }

        return request
    }

    @discardableResult func speakersList(with page: Int, perPage: Int, completionHandler: @escaping (NetworkReponse<NetworkPage<Speaker>>) -> ()) -> DataRequest {
        let request = Alamofire.request(NetworkRouter.speakersList([Constants.perPage: perPage, Constants.page: page]))
        request.responseJSON { response in
            response.result.responsePage(for: Constants.speakers, completionHandler: completionHandler)
        }

        return request
    }

    @discardableResult func eventDetails(with id: Int, completionHandler: @escaping (NetworkReponse<Event>) -> ()) -> DataRequest {
        let request = Alamofire.request(NetworkRouter.eventDetails(id))
        request.responseJSON { response in
            response.result.responseObject(for: Constants.event, completionHandler: completionHandler)
        }

        return request
    }
}
