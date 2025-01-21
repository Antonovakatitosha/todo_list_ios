//
//  AppLaunchManager.swift
//  ToDo List
//
//  Created by Kate Evdochenko on 1/21/25.
//

import Foundation

class LaunchService {
    private static let firstLaunchKey = "isFirstLaunch"

    static func isFirstLaunch() -> Bool {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: LaunchService.firstLaunchKey) {
            return false
        } else {
            userDefaults.set(true, forKey: LaunchService.firstLaunchKey)
            return true
        }
    }
}

