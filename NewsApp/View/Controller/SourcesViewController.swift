//
//  SourcesViewController.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import UIKit
import PKHUD
import Toast_Swift
import RxSwift
import RxCocoa

class SourcesViewController: UIViewController {

    @IBOutlet var sourceTableView: UITableView!
    
    var isSearch: Bool = false
    var viewModel = SourceViewModel()
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
    
    // MARK: - Override
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "Sources for \(self.viewModel.category?.categoryTitle ?? "Category")"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
        self.setupBinding()
        self.fetchData()
    }
    
    private func setupView() {
        sourceTableView.register(UINib(nibName: "SourceTableViewCell", bundle: nil), forCellReuseIdentifier: "SourceTableViewCell")
        sourceTableView.separatorStyle = .none
        sourceTableView.estimatedRowHeight = 84.0
        sourceTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupBinding() {
        self.viewModel.sourcesPublished.subscribe(onNext: { model in
            self.isLoading = false
            self.sourceTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func fetchData() {
        self.isLoading = true
        self.viewModel.requestNewsSources()
    }

}

extension SourcesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.isSearch ? self.viewModel.searchSources().count:self.viewModel.listSources.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceTableViewCell", for: indexPath) as! SourceTableViewCell
        
        let model = (self.isSearch ? self.viewModel.searchSources()[indexPath.row]:self.viewModel.listSources[indexPath.row])
        cell.sourceData = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = (self.isSearch ? self.viewModel.searchSources()[indexPath.row]:self.viewModel.listSources[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = ArticlesViewController()
        controller.viewModel.category = self.viewModel.category
        controller.viewModel.source = model
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
