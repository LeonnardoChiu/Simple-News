//
//  NewsBookmarkProtocol.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 22/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation
import UIKit

protocol BookmarkViewToPresenterProtocol: class {
    var view: BookmarkPresenterToViewProtocol? {get set}
    var interactor: BookmarkPresenterToInteractorProtocol? {get set}
    var router: BookmarkPresenterToRouteProtocol? {get set}
    
    func segueToNewsDetail(selectedIndex: IndexPath, newsList: [NewsDetail], arrayOfImage: [UIImage], navigationController: UINavigationController)
}

protocol BookmarkPresenterToViewProtocol: class {
    
}

protocol BookmarkPresenterToRouteProtocol: class {
    static func createModule() -> NewsBookmarkViewController
    
    func pushToNewsDetail(selectedIndex: IndexPath, newsList: [NewsDetail], arrayOfImage: [UIImage], navigationController: UINavigationController)
}

protocol BookmarkPresenterToInteractorProtocol: class {
    var presenter: BookmarkInteractorToPresenterProtocol? {get set}
    
}

protocol BookmarkInteractorToPresenterProtocol: class {
    
}
