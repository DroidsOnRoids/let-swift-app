//
//  NetworkImageView.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 25.05.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import UIKit
import Alamofire

final class NetworkImageView: UIImageView {
    
    private var pendingRequest: DataRequest?
    
    var imageDownloadedObservable = Observable<Void>()
    
    var imageURL: URL? {
        didSet {
            guard let imageURL = imageURL else { return }
            fetchImage(fromURL: imageURL)
        }
    }
    
    private func fetchImage(fromURL url: URL) {
        if let pendingRequest = pendingRequest {
            pendingRequest.cancel()
        }
        
        pendingRequest = NetworkProvider.shared.alamofireManager.request(url)
        pendingRequest?.responseData { [weak self] response in
            self?.pendingRequest = nil
            guard let data = response.result.value, let newImage = UIImage(data: data) else { return }
            self?.image = newImage
            self?.imageDownloadedObservable.next()
        }
    }
}
