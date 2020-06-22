//
//  Constants.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 20/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation

struct ApiConstant {
    
    static let apiKey = "SvOzslO2gggNsCjIcmQBY9aIXbEE4EY2"
    static let baseUrl = "https://api.nytimes.com/"
//    static let imageBaseUrl = "https://static01.nyt.com/"
    static let imageBaseUrl = "https://www.nytimes.com/"
}

struct UserDefaultConstant {
    static let searchHistory = "searchHistory"
    static let bookmarkList = "bookmarkList"
    static let offlineNews = "offlineNews"
}

enum NewsError: Error {
    case noDataAvailable
    case canNotProcessData
}
