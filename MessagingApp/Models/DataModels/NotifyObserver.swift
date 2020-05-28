//
//  NotifyObserver.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 4/5/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol NotifyObserver {
    func friendUpdate(updateData: [(QueryDocumentSnapshot, UIImage)]) -> Void
    func userInformationUpdate(newInformation: (UserDetail, UIImage)) -> Void
}

protocol NotifyObservee {
    func registerFriendObserver(observer: NotifyObserver)
    func registerUserObserver(observer: NotifyObserver)
    func friendUpdate()
    func userUpdate()
}
