//
//  NewsBookmarkViewController.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 22/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import UIKit

class NewsBookmarkViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var presentor: BookmarkViewToPresenterProtocol?
    
    var newsList = [NewsDetail]()
    
    var arrayOfImage = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        loadBookmark()
        
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    func loadBookmark() {
        if let data = UserDefaults.standard.value(forKey: UserDefaultConstant.bookmarkList) as? Data {
            let decodedNews = try? PropertyListDecoder().decode([NewsDetail].self, from: data)
            
            newsList = decodedNews!
            
            for news in newsList {
                if news.multimedia?.count != 0 {
                    arrayOfImage.append(getNewsImage(imageURL: news.multimedia?[0].url ?? ""))
                }
                else {
                    arrayOfImage.append(UIImage(systemName: "eye.slash")!)
                }
            }
            
            tableView.reloadData()
            
        }
    }
    
    func getNewsImage(imageURL: String) -> UIImage {
        let urlKey = "\(ApiConstant.imageBaseUrl)\(imageURL)"
        let noImage = UIImage(systemName: "eye.slash")
        var newsImage:UIImage?
        
        if let url = URL(string: urlKey) {
            do{
                let data = try Data(contentsOf: url)
                newsImage = UIImage(data: data)
                
            }catch let error {
                print(error.localizedDescription)
            }
            return newsImage ?? noImage!
        }
        
        return noImage!
    }

}

extension NewsBookmarkViewController: BookmarkPresenterToViewProtocol {
    
}

extension NewsBookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsList.count != 0 {
            return newsList.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if newsList.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookmarkCell
            
            cell.textLabel?.text = newsList[indexPath.row].headline?.main
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noBookmarkCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath
        
        presentor?.segueToNewsDetail(selectedIndex: selectedIndex, newsList: newsList, arrayOfImage: arrayOfImage, navigationController: navigationController!)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            newsList.remove(at: indexPath.row)
            
            let encodedNews = try? PropertyListEncoder().encode(newsList)
            
            UserDefaults.standard.set(encodedNews, forKey: UserDefaultConstant.bookmarkList)
            
            tableView.reloadData()
        }
    }
    
    
}

class BookmarkCell: UITableViewCell {
    
}
