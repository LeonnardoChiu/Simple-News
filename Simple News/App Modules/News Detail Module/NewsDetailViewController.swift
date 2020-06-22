//
//  NewsDetailViewController.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 21/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var presentor:DetailViewToPresenterProtocol?
    
    var selectedIndex = IndexPath()
    
    var newsList = [NewsDetail]()
    
    var arrayOfImage = [UIImage]()
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBarItem()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionViewLayout()
        
        currentPage = selectedIndex.item
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: self.selectedIndex, at: .centeredHorizontally, animated: false)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
    }
    
    func setUpNavigationBarItem() {
        let bookmark = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(bookmarkTapped))
        
        navigationItem.rightBarButtonItem = bookmark
    }
    
    @objc func bookmarkTapped() {
        let bookmarkAlert = UIAlertController(title: "Bookmark News", message: "Are you want to bookmark this news?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        let okAction = UIAlertAction(title: "Bookmark", style: .default) { (action) in
            if let data = UserDefaults.standard.value(forKey: UserDefaultConstant.bookmarkList) as? Data {
                var decodedNews = try? PropertyListDecoder().decode([NewsDetail].self, from: data)
                
                decodedNews?.append(self.newsList[self.currentPage])
                
                let encodedNews = try? PropertyListEncoder().encode(decodedNews)
                
                UserDefaults.standard.set(encodedNews, forKey: UserDefaultConstant.bookmarkList)
                
            }
            else {
                var bookmarkList = [NewsDetail]()
                    
                bookmarkList.append(self.newsList[self.currentPage])
                
                let encodedNews = try? PropertyListEncoder().encode(bookmarkList)
                
                UserDefaults.standard.set(encodedNews, forKey: UserDefaultConstant.bookmarkList)
            }
        
        }
        
        bookmarkAlert.addAction(cancelAction)
        bookmarkAlert.addAction(okAction)
        
        self.present(bookmarkAlert, animated: true, completion: nil)
        
    }
    
    @objc func articleTapped() {
        let urlString = newsList[currentPage].web_url!
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
}

extension NewsDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsDetailCell
        
        cell.imgView.image = arrayOfImage[indexPath.item]
        cell.titleLabel.text = newsList[indexPath.item].headline?.main
        cell.paragraphLabel.text = newsList[indexPath.item].lead_paragraph
        
        cell.fullArticleButton.addTarget(self, action: #selector(articleTapped), for: .touchUpInside)
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        self.currentPage = Int(ceil(x/w))
    }
    
}

extension NewsDetailViewController: DetailPresenterToViewProtocol {
    
}

class NewsDetailCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var paragraphLabel: UILabel!
    @IBOutlet var fullArticleButton: UIButton!
    
}
