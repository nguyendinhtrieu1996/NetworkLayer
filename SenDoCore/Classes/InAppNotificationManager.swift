//
//  InAppNotificationManager.swift
//  Buyer
//
//  Created by Nguyen Dinh Trieu on 2/14/19.
//  Copyright © 2019 Sendo.vn. All rights reserved.
//

import Foundation

class InAppNotificationManager {
    static var shared = InAppNotificationManager()
    private (set) var numberUnSeenMessages = 0
    
    private init() {
    }
    
    func fetchUnSeenMessage() {
        DataProxy.user.fetchUnSeenNotificationMessages(onSuccess: { [weak self] (numberMessages) in
            guard let strongSelf = self, strongSelf.numberUnSeenMessages != numberMessages else {
                return
            }
            
            UIApplication.shared.applicationIconBadgeNumber = numberMessages ?? 0
            strongSelf.numberUnSeenMessages = numberMessages ?? 0
            strongSelf.sendNotificationReloadTabbarBadgeNumber()
        }) { [weak self] in
            self?.sendNotificationReloadTabbarBadgeNumber()
        }
    }
    
    func resetNotification() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        numberUnSeenMessages = 0
        sendNotificationReloadTabbarBadgeNumber()
    }
    
    func increaseNotification() {
        numberUnSeenMessages += 1
        sendNotificationReloadTabbarBadgeNumber()
    }
    
    private func sendNotificationReloadTabbarBadgeNumber() {
        NotificationCenter.default.post(name: NSNotification.Name.reloadBadgeNumberTabbar, object: nil)
    }
    
}
