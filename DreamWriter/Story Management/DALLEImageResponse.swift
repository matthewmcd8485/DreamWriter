//
//  DALLEImageResponse.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/10/24.
//

import Foundation

struct DALLEImageResponse: Codable {
    let data: [DALLEImageData]
    
    struct DALLEImageData: Codable {
        let url: String
    }
}
