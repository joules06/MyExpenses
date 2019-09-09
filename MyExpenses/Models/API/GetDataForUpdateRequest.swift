//
//  GetDataForUpdateRequest.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/8/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation
class GetDataForUpdateRequest: Codable {
    let categories, years, months, versionControl: String
    let responseCode, responseStatus: String
    
    enum CodingKeys: String, CodingKey {
        case categories, years, months
        case versionControl = "version_control"
        case responseCode = "response_code"
        case responseStatus = "response_status"
    }
    
    init(categories: String, years: String, months: String, versionControl: String, responseCode: String, responseStatus: String) {
        self.categories = categories
        self.years = years
        self.months = months
        self.versionControl = versionControl
        self.responseCode = responseCode
        self.responseStatus = responseStatus
    }
}
