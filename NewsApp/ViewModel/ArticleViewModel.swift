//
//  ArticleViewModel.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import Foundation
import RxSwift
import Alamofire
import RxCocoa

class ArticleViewModel: NSObject {
    
    var listArticles = [NewsItemModel]()
    var category: NewsCategory?
    var source: NewsSourceModel?
    var keyword: String = ""
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let articlesPublished: PublishSubject<[NewsItemModel]>  = PublishSubject()
    public let error : PublishSubject<NSError> = PublishSubject()
    private let disposable = DisposeBag()
    
    public func requestNewsArticles(){
        self.loading.onNext(true)
        ApiManager.instance.getArticleList(sourceId: self.source?.id ?? "", keyword: self.keyword)
            .do( onNext : { model in
                self.loading.onNext(false)
                self.listArticles = model
                self.articlesPublished.onNext(model)
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
