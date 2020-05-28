//
//  NotifyObserver.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 4/5/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
protocol NotifyObserver {
    func friendUpdate() -> Void
}

protocol NotifyObservee {
    func registerObserver(observer: NotifyObserver)
    func friendUpdate()
}
