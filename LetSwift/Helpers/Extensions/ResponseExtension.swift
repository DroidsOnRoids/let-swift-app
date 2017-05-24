//
//  ResponseExtension.swift
//  LetSwift
//
//  Created by Kinga Wilczek on 22.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Mapper
import Alamofire

extension Result {
    func responseArray<Element: Mappable>(for keyPath: String? = nil, completionHandler: (NetworkReponse<[Element]>) -> ()) {
        switch self {
        case .success:
            var parsedObject: [Element]?

            if let keyPath = keyPath {
                parsedObject = parseArray(for: keyPath)
            } else {
                parsedObject = parseArray()
            }

            guard let object = parsedObject else {
                return completionHandler(.error(NetworkError.invalidObjectParse))
            }

            completionHandler(.success(object))
        case .failure(let error):
            completionHandler(.error(error))
        }
    }

    func responseObject<Element: Mappable>(for keyPath: String? = nil, completionHandler: (NetworkReponse<Element>) -> ()) {
        switch self {
        case .success:
            var parsedObject: Element?

            if let keyPath = keyPath {
                parsedObject = parseObject(for: keyPath)
            } else {
                parsedObject = parseObject()
            }

            guard let object = parsedObject else {
                return completionHandler(.error(NetworkError.invalidObjectParse))
            }

            completionHandler(.success(object))
        case .failure(let error):
            completionHandler(.error(error))
        }
    }

    func responsePage<Element: Mappable>(for keyPath: String, completionHandler: (NetworkReponse<NetworkPage<Element>>) -> ()) {
        switch self {
        case .success:
            guard let parsedArray: [Element] = parseArray(for: keyPath), let page: Page = parseObject() else {
                return completionHandler(.error(NetworkError.invalidObjectParse))
            }

            completionHandler(.success(NetworkPage(page: page, elements: parsedArray)))
        case .failure(let error):
            completionHandler(.error(error))
        }
    }

    func parseObject<Element: Mappable>() -> Element? {
        guard let json = value as? NSDictionary,
            let object = Element.from(json) else {
                return nil
        }
        return object
    }

    func parseObject<Element: Mappable>(for keyPath: String) -> Element? {
        guard let json = value as? NSDictionary,
            let objectJson = json[keyPath] as? NSDictionary,
            let object = Element.from(objectJson) else {
                return nil
        }
        return object
    }

    func parseArray<Element: Mappable>() -> [Element]? {
        guard let json = value as? NSArray,
            let object = Element.from(json) else {
                return nil
        }
        return object
    }

    func parseArray<Element: Mappable>(for keyPath: String) -> [Element]? {
        guard let json = value as? NSDictionary,
            let objectJson = json[keyPath] as? NSArray,
            let object = Element.from(objectJson) else {
                return nil
        }
        return object
    }
}
