//
//  NewsListPresenter.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 20/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation
import UIKit

class NewsListPresenter: ViewToPresenterProtocol {
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouteProtocol?
    
    func startRequestNews(page: Int, query: String) {
        interactor?.requestNews(page: page, query: query)
    }
    
    func segueToNewsDetail(selectedIndex: IndexPath, newsList: [NewsDetail], arrayOfImage: [UIImage], navigationController: UINavigationController) {
        router?.pushToNewsDetail(selectedIndex: selectedIndex, newsList: newsList, arrayOfImage: arrayOfImage, navigationController: navigationController)
    }

}


extension NewsListPresenter: InteractorToPresenterProtocol {
    func newsRequestSuccess(newsResponse: NewsDocs) {
        view?.showNews(news: newsResponse)
    }
    
    func newsRequestFailed(error: String) {
        print(error)
    }
    
    
}
