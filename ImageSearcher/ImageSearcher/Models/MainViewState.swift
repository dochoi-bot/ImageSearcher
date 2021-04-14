//
//  MainViewState.swift
//  ImageSearcher
//
//  Created by 최동규 on 2021/04/14.
//

import Foundation

struct MainViewState {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    let pageIndex: Int
    var isPagianting = false
}
