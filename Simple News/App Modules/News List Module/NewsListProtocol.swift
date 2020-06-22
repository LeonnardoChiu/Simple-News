//
//  NewsListProtocol.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 20/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: class {
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouteProtocol? {get set}
    
    func startRequestNews(page: Int, query: String)
    
    func segueToNewsDetail(selectedIndex: IndexPath, newsList: [NewsDetail], arrayOfImage: [UIImage], navigationController: UINavigationController)
}

protocol PresenterToViewProtocol: class {
    func showNews(news: NewsDocs)
}

protocol PresenterToRouteProtocol: class {
    static func createModule() -> NewsListViewController
    
    func pushToNewsDetail(selectedIndex: IndexPath, newsList: [NewsDetail], arrayOfImage: [UIImage], navigationController: UINavigationController)
}

protocol PresenterToInteractorProtocol: class {
    var presenter: InteractorToPresenterProtocol? {get set}
    
    func requestNews(page: Int, query: String)
}

protocol InteractorToPresenterProtocol: class {
    func newsRequestSuccess(newsResponse: NewsDocs)
    func newsRequestFailed(error: String)
}
