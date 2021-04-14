//
//  ImageEndPoint.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/11.
//

import Foundation

struct ImageEndPoint: RequestType {
    var header: [String : String]
    var url: URL? = URL(string: "https://dapi.kakao.com/v2/search/image")
    var parameter: [String: String] = [:]
    var method: RequestMethod
    var body: Data?
}
