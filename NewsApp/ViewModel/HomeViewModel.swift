//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import Foundation
import RxSwift
import Alamofire
import RxCocoa

class HomeViewModel: NSObject {
    
    var listCategory:[NewsCategory] = [.all, .business, .entertainment, .general, .health, .science, .sports, .sports, .technology]
    var listHeadlines = [NewsItemModel]()
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let headlinePublished: PublishSubject<[NewsItemModel]>  = PublishSubject()
    public let error : PublishSubject<NSError> = PublishSubject()
    private let disposable = DisposeBag()
    
    public func requestHeadlineNews(){
        self.loading.onNext(true)
        ApiManager.instance.getHeadlineList()
            .do( onNext : { model in
                self.loading.onNext(false)
                self.listHeadlines = model
                self.headlinePublished.onNext(model)
            }, onError : {
                errorType in
                self.loading.onNext(false)
                let error = errorType as NSError
                self.error.onNext(error)
            })
            .subscribe()
            .disposed(by: self.disposable)
    }
}
