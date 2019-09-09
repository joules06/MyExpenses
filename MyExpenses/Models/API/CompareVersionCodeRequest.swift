//
//  CompareVersionCodeRequest.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation

class CompareVersionCodeRequest: Codable {
    let versionCode: Int
    
    enum CodingKeys: String, CodingKey {
        case versionCode = "version_code"
    }
    
    init(versionCode: Int) {
        self.versionCode = versionCode
    }
}
