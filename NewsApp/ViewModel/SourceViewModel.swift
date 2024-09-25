//
//  SourceViewModel.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import Foundation
import RxSwift
import Alamofire
import RxCocoa

class SourceViewModel: NSObject {
    
    var listSources = [NewsSourceModel]()
    var category: NewsCategory?
    var keyword: String = ""
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let sourcesPublished: PublishSubject<[NewsSourceModel]>  = PublishSubject()
    public let error : PublishSubject<NSError> = PublishSubject()
    private let disposable = DisposeBag()
    
    public func requestNewsSources(){
        self.loading.onNext(true)
        ApiManager.instance.getSourceList(category: self.category?.categoryName ?? "")
            .do( onNext : { model in
                self.loading.onNext(false)
                self.listSources = model
                self.sourcesPublished.onNext(model)
            }, onError : {
                errorType in
                self.loading.onNext(false)
                let error = errorType as NSError
                self.error.onNext(error)
            })
            .subscribe()
            .disposed(by: self.disposable)
    }
    
    public func searchSources() -> [NewsSourceModel] {
        var filteredList = [NewsSourceModel]()
        filteredList = listSources.filter({ source in
            return source.name.lowercased().contains(self.keyword)
        })
        
        return filteredList
    }
}
