//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import UIKit
import PKHUD
import Toast_Swift
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet var headlineCollectionView: UICollectionView!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var categoryCollectionHeight: NSLayoutConstraint!
    
    var viewModel = HomeViewModel()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "THE NEWS"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
        self.setupBinding()
        self.fetchData()
    }
    
    private func setupView() {
        headlineCollectionView.register(UINib(nibName: "TopHeadlineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopHeadlineCollectionViewCell")
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        categoryCollectionView.isScrollEnabled = false
    }
    
    private func setupBinding() {
        self.viewModel.headlinePublished.subscribe(onNext: { model in
            guard model.count > 0 else {
                self.isLoading = false
                self.headlineCollectionView.reloadData()
                return
            }
            self.headlineCollectionView.reloadData()
            self.isLoading = false
        }).disposed(by: disposeBag)
    }
    
    private func fetchData() {
        self.isLoading = true
        self.viewModel.requestHeadlineNews()
        
        self.categoryCollectionView.reloadData()
        let width = categoryCollectionView.frame.width / 2
        let height = width / 1.46
        if self.viewModel.listCategory.count % 2 == 0 {
            self.categoryCollectionHeight.constant = CGFloat(self.viewModel.listCategory.count / 2) * height
        } else {
            self.categoryCollectionHeight.constant = CGFloat((self.viewModel.listCategory.count / 2) + 1) * height
        }
    }

}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headlineCollectionView {
            return self.viewModel.listHeadlines.count
        }
        else if collectionView == categoryCollectionView {
            return self.viewModel.listCategory.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headlineCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHeadlineCollectionViewCell", for: indexPath) as! TopHeadlineCollectionViewCell
            
            let model = self.viewModel.listHeadlines[indexPath.row]
            cell.headlineData = model
            
            return cell
        }
        else if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            
            let model = self.viewModel.listCategory[indexPath.row]
            cell.categoryData = model
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        if collectionView == headlineCollectionView {
            width = collectionView.frame.height
            height = collectionView.frame.height
        }
        else if collectionView == categoryCollectionView {
            width = collectionView.frame.width / 2
            height = width / 1.46
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headlineCollectionView {
            let model = self.viewModel.listHeadlines[indexPath.row]
        }
        else if collectionView == categoryCollectionView {
            let model = self.viewModel.listCategory[indexPath.row]
            
            let controller = SourcesViewController()
            controller.viewModel.category = model
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
