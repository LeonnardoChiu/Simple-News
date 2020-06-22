//
//  NewsDetailRouter.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 21/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation
import UIKit

class NewsDetailRouter: DetailPresenterToRouteProtocol {
    static func createModule(selectedIndex: IndexPath, newsList: [NewsDetail], arrayOfImage: [UIImage]) -> NewsDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let view = storyboard.instantiateViewController(identifier: "NewsDetailViewController") as! NewsDetailViewController
        
        view.selectedIndex = selectedIndex
        view.newsList = newsList
        view.arrayOfImage = arrayOfImage
        
        let presenter: DetailViewToPresenterProtocol & DetailInteractorToPresenterProtocol = NewsDetailPresenter()
        let interactor: DetailPresenterToInteractorProtocol = NewsDetailInteractor()
        let router: DetailPresenterToRouteProtocol = NewsDetailRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
}
