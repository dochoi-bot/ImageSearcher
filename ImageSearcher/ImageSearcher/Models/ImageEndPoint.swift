//
//  ImageEndPoint.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/11.
//

import Foundation

struct ImageEndPoint: RequestType {
    
    var url: URL? = URL(string: "https://dapi.kakao.com/v2/search/image")
    var parameter: [String: String] = [:]
    var method: RequestMethod
    var body: Data?
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let meta: Meta
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let collection: String
    let thumbnailURL: String
    let imageURL: String
    let width, height: Int
    let displaySitename: String
    let docURL: String
    let datetime: String

    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width, height
        case displaySitename = "display_sitename"
        case docURL = "doc_url"
        case datetime
    }
}

// MARK: - Meta
struct Meta: Codable {
    let totalCount, pageableCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}
