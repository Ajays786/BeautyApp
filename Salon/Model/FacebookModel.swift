//
//  FacebookModel.swift
//  Salon
//
//  Created by Rahul Tiwari on 6/11/19.
//  Copyright © 2019 Hengyu Liu. All rights reserved.
//

import Foundation
// MARK: - KFacebookModel
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let kFacebookModel = try? newJSONDecoder().decode(KFacebookModel.self, from: jsonData)

import Foundation

// MARK: - KFacebookModel
struct KFacebookModel: Codable {
    let email: String?
    let picture: KPicture?
    let firstName, name, lastName, id: String?
    
    enum CodingKeys: String, CodingKey {
        case email, picture
        case firstName = "first_name"
        case name
        case lastName = "last_name"
        case id
    }
}

// MARK: - KPicture
struct KPicture: Codable {
    let data: KData?
}

// MARK: - KData
struct KData: Codable {
    let url: String?
    let isSilhouette: Bool?
    let width, height: Int?
    
    enum CodingKeys: String, CodingKey {
        case url
        case isSilhouette = "is_silhouette"
        case width, height
    }
}

