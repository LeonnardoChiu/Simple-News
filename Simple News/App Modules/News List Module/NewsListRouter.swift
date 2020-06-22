//
//  NewsListRouter.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 20/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation
import UIKit

class NewsListRouter: PresenterToRouteProtocol {
    
    static func createModule() -> NewsListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let view = storyboard.instantiateViewController(identifier: "NewsListViewController") as! NewsListViewController
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = NewsListPresenter()
        let interactor: PresenterToInteractorProtocol = NewsListInteractor()
        let router: PresenterToRouteProtocol = NewsListRouter()
        
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
