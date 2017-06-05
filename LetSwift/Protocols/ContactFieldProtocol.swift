//
//  ContactFieldProtocol.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 05.06.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//

import Foundation

protocol ContactFieldBaseProtocol: class {
    var fieldState: ContactFieldState { get set }
}

protocol ContactFieldProtocol: ContactFieldBaseProtocol {
    var textObservable: Observable<String> { get }
}
