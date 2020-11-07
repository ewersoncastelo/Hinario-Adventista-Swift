//
//  AddAccountModel.swift
//  Domain
//
//  Created by ewerson castelo on 07/11/20.
//  Copyright © 2020 Ewerson Castelo. All rights reserved.
//

import Foundation

public struct AddAccountModel {
    var email: String
    var password: String
    
    public init(email: String, password: String){
        self.email = email
        self.password = password
    }
}
