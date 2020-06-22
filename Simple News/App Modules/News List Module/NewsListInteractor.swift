//
//  NewsListInteractor.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 20/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation
import UIKit

class NewsListInteractor: PresenterToInteractorProtocol {
    
    var presenter: InteractorToPresenterProtocol?
    
    func requestNews(page: Int, query: String){
        let formattedQuery = query.replacingOccurrences(of: " ", with: "-")
        
        let resourceString = "\(ApiConstant.baseUrl)svc/search/v2/articlesearch.json?q=\(formattedQuery)&page=\(page)&api-key=\(ApiConstant.apiKey)"
        
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, error in
            guard let jsonData = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let parsedJSON = try
                    decoder.decode(NewsResponse.self, from: jsonData)
                let response = parsedJSON.response
                
                self.presenter?.newsRequestSuccess(newsResponse: response)
                
            }
            catch {
                self.presenter?.newsRequestFailed(error: error.localizedDescription)
            }
            
        }
        dataTask.resume()
        
        
    }
    
}
