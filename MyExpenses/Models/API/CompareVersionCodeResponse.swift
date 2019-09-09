//
//  CompareVersionCodeResponse.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
class CompareVersionCodeResponse: Codable {
    let differenceBetweenVersionCode: Int
    let responseCode, responseStatus: String
    
    enum CodingKeys: String, CodingKey {
        case differenceBetweenVersionCode = "difference_between_version_code"
        case responseCode = "response_code"
        case responseStatus = "response_status"
    }
    
    init(differenceBetweenVersionCode: Int, responseCode: String, responseStatus: String) {
        self.differenceBetweenVersionCode = differenceBetweenVersionCode
        self.responseCode = responseCode
        self.responseStatus = responseStatus
    }
}
