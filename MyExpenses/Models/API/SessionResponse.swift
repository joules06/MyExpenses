//
//  SessionResponse.swift
//  MyExpenses
//
//  Created by Julio Rico on 9/9/19.
//  Copyright © 2019 Julio Rico. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let token, responseCode, responseStatus: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case responseCode = "response_code"
        case responseStatus = "response_status"
    }
}
