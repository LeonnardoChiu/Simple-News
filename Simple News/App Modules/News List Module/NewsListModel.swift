//
//  NewsListModel.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 20/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation

struct NewsResponse: Codable {
    var response: NewsDocs
}

struct NewsDocs: Codable {
    var docs: [NewsDetail]
    
}

struct NewsDetail: Codable {
    var _id: String?
    var pub_date: String?
    var abstract: String?
    var web_url: String?
    var snippet: String?
    var lead_paragraph: String?
    var headline: NewsHeadline?
    var multimedia: [NewsMultimedia]?
}

struct NewsHeadline: Codable {
    var main: String?
    
}

struct NewsMultimedia: Codable {
    var url: String?
    var type: String?
    var subtype: String?
    
}
