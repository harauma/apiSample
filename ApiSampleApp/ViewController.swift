//
//  ViewController.swift
//  ApiSampleApp
//
//  Created by 原涼馬 on 2020/05/21.
//  Copyright © 2020 原涼馬. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    fileprivate var articles: [[String: Any]] = [] { // fileprivateを追加
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles() // メソッドに切り出し
        initTableView() // メソッドに切り出し
    }
    
    private func fetchArticles() {
        guard let url: URL = URL(string: "http://qiita.com/api/v2/items") else { return }
        let task: URLSessionTask  = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            do {
                guard let data = data else { return } // guard letに書き換え
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Any] else { return } // guard letに書き換え
                let articles = json.flatMap { (article) -> [String: Any]? in
                    return article as? [String: Any]
                } // flatMapに書き換え
                DispatchQueue.main.async() { () -> Void in
                    self.articles = articles
                }
            }
            catch {
                print(error)
            }
        })
        task.resume()
    }
    
    private func initTableView() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let article = articles[indexPath.row]
        let title = article["title"] as? String ?? "" // nil合体演算子を使用
        cell.textLabel?.text = "tittle: \(title)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section) index: \(indexPath.row)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        return
    }
}

