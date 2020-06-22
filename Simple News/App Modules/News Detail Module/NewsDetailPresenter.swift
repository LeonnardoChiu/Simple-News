//
//  NewsDetailPresenter.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 21/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation

class NewsDetailPresenter: DetailViewToPresenterProtocol {
    var view: DetailPresenterToViewProtocol?
    
    var interactor: DetailPresenterToInteractorProtocol?
    
    var router: DetailPresenterToRouteProtocol?
    
}

extension NewsDetailPresenter: DetailInteractorToPresenterProtocol {
    
}
