//
//  NewsDetailProtocol.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 21/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import Foundation

import UIKit

protocol DetailViewToPresenterProtocol: class {
    var view: DetailPresenterToViewProtocol? {get set}
    var interactor: DetailPresenterToInteractorProtocol? {get set}
    var router: DetailPresenterToRouteProtocol? {get set}
    
}

protocol DetailPresenterToViewProtocol: class {
    
}

protocol DetailPresenterToRouteProtocol: class {
    static func createModule(selectedIndex: IndexPath, newsList: [NewsDetail], arrayOfImage: [UIImage]) -> NewsDetailViewController
}

protocol DetailPresenterToInteractorProtocol: class {
    var presenter: DetailInteractorToPresenterProtocol? {get set}
    
}

protocol DetailInteractorToPresenterProtocol: class {
    
}
