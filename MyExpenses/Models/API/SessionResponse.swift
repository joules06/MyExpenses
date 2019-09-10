//
//  SessionResponse.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/9/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation

class SessionResponse: Codable {
    let token: String?
    let responseCode, responseStatus: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case responseCode = "response_code"
        case responseStatus = "response_status"
    }
    
    init(token: String?, responseCode: String, responseStatus: String) {
        self.token = token
        self.responseCode = responseCode
        self.responseStatus = responseStatus
    }
}

