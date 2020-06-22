//
//  NewsListViewController.swift
//  Simple News
//
//  Created by Leonnardo Benjamin Hutama on 20/06/20.
//  Copyright © 2020 Leonnardo Benjamin Hutama. All rights reserved.
//

import UIKit
import SystemConfiguration

class NewsListViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
   
    @IBOutlet var collectionView: UICollectionView!
    
    var presentor:ViewToPresenterProtocol?
    
    var newsList = [NewsDetail]()
    
    var arrayOfImage = [UIImage]()
    
    var searchHistory = [String]()
    
    var filteredSearchHistory = [String]()
    
    let searchHistoryTableView = UITableView()
    
    let formatter = DateFormatter()
    
    var isSearching = false
    
    var fetchMoreNews = false
    
    var pageNumber = 1
    
    var query = ""
    
    let waitAlert = UIAlertController(title: "Fetching News", message: "Please wait", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "dd MMMM yyyy"

        self.present(waitAlert, animated: true) {
            
            self.checkConnection()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        var offlineNews = [NewsDetail]()
        
        for i in 0...9 {
            offlineNews.append(newsList[i])
        }
        
        let encodedNews = try? PropertyListEncoder().encode(offlineNews)
        
        UserDefaults.standard.set(encodedNews, forKey: UserDefaultConstant.offlineNews)
        
    }
    
    func checkConnection() {
        if Reachability.isConnectedToNetwork() {
            if let history = UserDefaults.standard.array(forKey: UserDefaultConstant.searchHistory) {
                searchHistory = history as! [String]
            }

            self.title = "Simple News"
            
            initCollectionView(newsPerRow: 1)
            
            initSearchBar()
            
            initSearchHistoryTable()
            
            presentor?.startRequestNews(page: pageNumber, query: "")
            
            searchBar.alpha = 1
        }
        else {
            self.title = "Offline News"
            
            searchBar.alpha = 0
            
            if let data = UserDefaults.standard.value(forKey: UserDefaultConstant.offlineNews) as? Data {
                let decodedNews = try? PropertyListDecoder().decode([NewsDetail].self, from: data)
                
                newsList = decodedNews!
                
            }
            
            for _ in  0...9 {
                arrayOfImage.append(UIImage(systemName: "eye.slash")!)
            }
            
            waitAlert.dismiss(animated: true, completion: nil)
        }
    }
    
    func initSearchBar() {
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search by Movie"
        searchBar.sizeToFit()
        
    }
    
    func initSearchHistoryTable() {
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.register(searchHistoryTableCell.self, forCellReuseIdentifier: "historyCell")
        
        searchHistoryTableView.backgroundColor = UIColor.clear
        searchHistoryTableView.tableFooterView = UIView()
    }
    
    func initCollectionView(newsPerRow: Int) {
        let itemWidth: CGFloat = UIScreen.main.bounds.width/CGFloat(newsPerRow) - 2
        let itemHeight: CGFloat = 380
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        collectionView.collectionViewLayout = layout
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
    
    func showSearchHistory() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        let screenSize = UIScreen.main.bounds.size
        let yPosition = CGFloat((self.navigationController?.navigationBar.frame.height)! + searchBar.frame.height + 42)
        
        searchHistoryTableView.frame = CGRect(x: 0, y: yPosition, width: screenSize.width, height: 0)
        
        window?.addSubview(searchHistoryTableView)

        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.searchHistoryTableView.frame = CGRect(x: 0, y: yPosition, width: screenSize.width, height: 500)
        }, completion: nil)
        
    }
    
    func hideSearchHistory() {
        let screenSize = UIScreen.main.bounds.size
        let yPosition = CGFloat((self.navigationController?.navigationBar.frame.height)! + searchBar.frame.height + 42)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.searchHistoryTableView.frame = CGRect(x: 0, y: yPosition, width: screenSize.width, height: 0)
            
        }, completion: nil)
        
        view.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
}

extension NewsListViewController: PresenterToViewProtocol {
    func showNews(news: NewsDocs) {
        
        let newsDetail = news.docs
        newsList.append(contentsOf: newsDetail)
        
        for news in newsDetail {
            if news.multimedia?.count != 0 {
                arrayOfImage.append(getNewsImage(imageURL: news.multimedia?[0].url ?? ""))
            }
            else {
                arrayOfImage.append(UIImage(systemName: "eye.slash")!)
            }
        }
        
        DispatchQueue.main.async {
            self.waitAlert.dismiss(animated: true, completion: nil)
            self.collectionView.reloadData()
        }
       
    }
    
}

extension NewsListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        showSearchHistory()
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
        hideSearchHistory()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        hideSearchHistory()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isSearching && searchBar.text == "" {
            isSearching =  true
        }
        else if !isSearching {
            isSearching = true
            showSearchHistory()
        }
        
        filteredSearchHistory = searchHistory.filter({ (history) -> Bool in
            return history.lowercased().contains(searchText.lowercased())
        })
        
        searchHistoryTableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        
        newsList.removeAll()
        
        arrayOfImage.removeAll()
        
        pageNumber = 1
        
        if searchBar.text != "" {
            searchHistory.append(searchBar.text!)
            query = searchBar.text!
            UserDefaults.standard.set(searchHistory, forKey: UserDefaultConstant.searchHistory)
        }
        hideSearchHistory()
        
        self.present(waitAlert, animated: true) {
            
            self.presentor?.startRequestNews(page: self.pageNumber, query: self.query)
        }
        
    }
    
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching && searchBar.text != "" {
            return filteredSearchHistory.count
        }
        else {
            return searchHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching && searchBar.text != "" {
            guard let cell = searchHistoryTableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? searchHistoryTableCell else { fatalError() }
            
            cell.titleLabel.text = filteredSearchHistory[indexPath.row]
            
            return cell
        }
        
        guard let cell = searchHistoryTableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? searchHistoryTableCell else { fatalError() }
                   
        cell.titleLabel.text = searchHistory[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedText = ""
        
        if isSearching && searchBar.text != "" {
            selectedText = filteredSearchHistory[indexPath.row]
            
        }
        else {
            selectedText = searchHistory[indexPath.row]
        }
        
        searchBar.text = selectedText
        
        query = selectedText
        
        newsList.removeAll()
        
        arrayOfImage.removeAll()
        
        hideSearchHistory()
        
        self.present(waitAlert, animated: true) {
            
            self.presentor?.startRequestNews(page: self.pageNumber, query: self.query)
        }
        
    }
    
    
}

extension NewsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let formattedDate = formatter.date(from: newsList[indexPath.item].pub_date!)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsListCell
        
        cell.imgView.image = arrayOfImage[indexPath.item]
        cell.titleLabel.text = newsList[indexPath.item].headline?.main
        cell.snippetLabel.text = newsList[indexPath.item].snippet
        cell.dateLabel.text = formatter.string(from: formattedDate ?? Date())
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            searchBar.endEditing(true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIndex = indexPath
        
        presentor?.segueToNewsDetail(selectedIndex: selectedIndex, newsList: newsList, arrayOfImage: arrayOfImage, navigationController: navigationController!)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        
        if scrollView == self.collectionView {
            let offSetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offSetY > contentHeight - scrollView.frame.height - UIScreen.main.bounds.height / 3 {
                if !fetchMoreNews {
                    pageNumber += 1
                    fetchMoreNews = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                            
                        self.presentor?.startRequestNews(page: self.pageNumber, query: self.query)
                        self.fetchMoreNews = false
                    })
                }
            }
        }
        
    }
    
}


class NewsListCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var snippetLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
}

class searchHistoryTableCell: UITableViewCell {

    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 10, width: self.frame.width - 80, height: 20))
        
        return titleLabel
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(titleLabel)
        // Configure the view for the selected state
    }

}

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
