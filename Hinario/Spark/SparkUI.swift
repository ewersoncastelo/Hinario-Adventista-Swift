//
//  SparkUI.swift
//  SwiftUISignInWithAppleAndFirebaseDemo
//
//  Created by Alex Nagy on 08/12/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import Foundation
import SwiftUI

struct AlertInfo {
    var isPresented: Bool
    var title: String
    var message: String
    var actionText: String
    var actionTag: Int
}

struct ActivityIndicatorInfo {
    var isPresented: Bool
    var message: String
}

struct SparkUIDefault {
    static let alertInfo = AlertInfo(isPresented: false, title: "", message: "", actionText: "", actionTag: 0)
    static let activityIndicatorInfo = ActivityIndicatorInfo(isPresented: false, message: "Working...")
}

