//
//  ImageSearcherTests.swift
//  ImageSearcherTests
//
//  Created by 최동규 on 2021/04/14.
//

import XCTest
@testable import ImageSearcher

final class NetworkServiceTests: XCTestCase {
    
    func test_search_Test_success() {
        let expectation = XCTestExpectation(description: "NetworkTaskExpectation")
        defer { wait(for: [expectation], timeout: 5.0)}
        let networkService = NetworkService()
        let endPoint = ImageEndPoint(header: ["Content-Type": "application/json", "Authorization": "KakaoAK cff5a3414b3a2d55dce43b07873577aa"], parameter: ["query": "Test"], method: .get)
        
        networkService.request(requestType: endPoint) { result in
            switch result {
            case let .success(data):
                let decoder = JSONDecoder()
                XCTAssertNoThrow(try? decoder.decode(APIResponse.self, from: data))
                expectation.fulfill()
            case let .failure(error):
                XCTFail("네트워크 서버 연결 실패\(error)")
            }
        }
    }
}

