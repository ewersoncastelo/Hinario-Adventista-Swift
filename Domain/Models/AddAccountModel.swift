//
//  AddAccountModel.swift
//  Domain
//
//  Created by ewerson castelo on 07/11/20.
//  Copyright © 2020 Ewerson Castelo. All rights reserved.
//

import Foundation

public struct AddAccountModel {
    var name: String
    var email: String
    var password: String
    
    public init(name: String, email: String, password: String){
        self.name = name
        self.email = email
        self.password = password
    }
}
