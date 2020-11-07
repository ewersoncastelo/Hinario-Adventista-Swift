//
//  AddAccount.swift
//  Domain
//
//  Created by ewerson castelo on 07/11/20.
//  Copyright © 2020 Ewerson Castelo. All rights reserved.
//

import Foundation

public protocol AddAccount {
    func AddWithEmail(addAccount: AddAccountModel, completion: @escaping (Result<AccountModel, Error>) -> Void)
}
