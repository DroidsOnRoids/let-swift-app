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
            self.parsePage(response: response, with: Constants.events, completionHandler: completionHandler)
        }

        return request
    }

    @discardableResult func speakersList(with page: Int, perPage: Int, completionHandler: @escaping (NetworkReponse<NetworkPage<Speaker>>) -> ()) -> DataRequest {
        let request = Alamofire.request(NetworkRouter.speakersList([Constants.perPage: perPage, Constants.page: page]))
        request.responseJSON { response in
            self.parsePage(response: response, with: Constants.speakers, completionHandler: completionHandler)
        }

        return request
    }

    @discardableResult func eventDetails(with id: Int, completionHandler: @escaping (NetworkReponse<Event>) -> ()) -> DataRequest {
        let request = Alamofire.request(NetworkRouter.eventDetails(id))
        request.responseJSON { response in
            self.parseObject(response: response, with: Constants.event, completionHandler: completionHandler)
        }

        return request
    }

    private func parsePage<Element>(response: DataResponse<Any>, with key: String, completionHandler: @escaping (NetworkReponse<NetworkPage<Element>>) -> ()) {
        switch response.result {
        case .success(let result):
            guard let json = result as? NSDictionary, let object = NetworkPage<Element>.from(json, with: key) else {
                return completionHandler(.error(NetworkError.invalidObjectParse))
            }

            completionHandler(.success(object))
        case .failure(let error):
            completionHandler(.error(error))
        }
    }

    private func parseObject<Element: Mappable>(response: DataResponse<Any>, with name: String, completionHandler: @escaping (NetworkReponse<Element>) -> ()) {
        switch response.result {
        case .success(let result):
            guard let json = result as? NSDictionary,
                let objectJson = json[name] as? NSDictionary,
                let object = Element.from(objectJson) else {
                return completionHandler(.error(NetworkError.invalidObjectParse))
            }

            completionHandler(.success(object))
        case .failure(let error):
            completionHandler(.error(error))
        }
    }

}
