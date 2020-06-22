//
//  NewsBookmarkPresenter.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 22/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation
import UIKit

class BookmarkPresenter: BookmarkViewToPresenterProtocol {
    var view: BookmarkPresenterToViewProtocol?
    
    var interactor: BookmarkPresenterToInteractorProtocol?
    
    var router: BookmarkPresenterToRouteProtocol?
    
    func segueToNewsDetail(selectedIndex: IndexPath, newsList: [NewsDetail], arrayOfImage: [UIImage], navigationController: UINavigationController) {
        router?.pushToNewsDetail(selectedIndex: selectedIndex, newsList: newsList, arrayOfImage: arrayOfImage, navigationController: navigationController)
    }
    
}

extension BookmarkPresenter: BookmarkInteractorToPresenterProtocol {
    
}
