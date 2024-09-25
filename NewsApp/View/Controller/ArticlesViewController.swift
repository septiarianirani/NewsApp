//
//  ArticlesViewController.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import UIKit
import PKHUD
import Toast_Swift
import RxSwift
import RxCocoa

class ArticlesViewController: UIViewController {

    @IBOutlet var articleTableView: UITableView!
    
    var isSearch: Bool = false
    var viewModel = ArticleViewModel()
    let disposeBag = DisposeBag()
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                HUD.show(.progress, onView: self.view)
                self.view.isUserInteractionEnabled = false
            } else {
                HUD.hide()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
        self.setupBinding()
        self.fetchData()
    }
    
    private func setupView() {
        articleTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        articleTableView.separatorStyle = .none
    }
    
    private func setupBinding() {
        self.viewModel.articlesPublished.subscribe(onNext: { model in
            self.isLoading = false
            self.articleTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func fetchData() {
        self.isLoading = true
        self.viewModel.requestNewsArticles()
    }

}

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell
        
        let model = self.viewModel.listArticles[indexPath.row]
        cell.articleData = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
