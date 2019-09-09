//
//  UpdateVersionCodeResponse.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
class UpdateVersionCodeResponse: Codable {
    let versionCode: Int
    let responseCode, responseStatus: String
    
    enum CodingKeys: String, CodingKey {
        case versionCode = "version_code"
        case responseCode = "response_code"
        case responseStatus = "response_status"
    }
    
    init(versionCode: Int, responseCode: String, responseStatus: String) {
        self.versionCode = versionCode
        self.responseCode = responseCode
        self.responseStatus = responseStatus
    }
}
