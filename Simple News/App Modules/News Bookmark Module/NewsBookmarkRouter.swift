//
//  NewsBookmarkRouter.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 22/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation
import UIKit

class BookmarkRouter: BookmarkPresenterToRouteProtocol {
    
    static func createModule() -> NewsBookmarkViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let view = storyboard.instantiateViewController(identifier: "BookmarkViewController") as! NewsBookmarkViewController
        
        let presenter: BookmarkViewToPresenterProtocol & BookmarkInteractorToPresenterProtocol = BookmarkPresenter()
        let interactor: BookmarkPresenterToInteractorProtocol = BookmarkInteractor()
        let router: BookmarkPresenterToRouteProtocol = BookmarkRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func pushToNewsDetail(selectedIndex: IndexPath, newsList: [NewsDetail], arrayOfImage: [UIImage], navigationController: UINavigationController) {
        let newsDetailModule = NewsDetailRouter.createModule(selectedIndex: selectedIndex, newsList: newsList, arrayOfImage: arrayOfImage)
        navigationController.pushViewController(newsDetailModule, animated: true)
    }
    

}
