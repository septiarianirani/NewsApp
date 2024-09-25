//
//  APIManager.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

class ApiManager: NSObject {
 
    public static let apiKey = "ded5995fc359499d9ef2b19da11de2e0"
    
    public static let url_master = "https://newsapi.org/v2"
    let allNewsUrl = "/everything?apiKey="+ApiManager.apiKey
    let headlinesUrl = "/top-headlines?apiKey="+ApiManager.apiKey+"&language=en"
    let headlineSourcesUrl = "/top-headlines/sources?apiKey="+ApiManager.apiKey
    
    static let instance = ApiManager()
    let manager: APISessionManager
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60*8
        manager = APISessionManager(configuration: configuration)
        super.init()
    }
    
    func getHeadlineList() -> Observable<[NewsItemModel]> {
        var url = ApiManager.url_master + headlinesUrl
        let request = manager.request( url, method: .get, parameters: [:], encoding: URLEncoding.default)
        let requests = request.rx_JSON()
            .mapJSONResponse()
            .map { response -> [NewsItemModel] in
                if response.status == "ok" {
                    var list = [NewsItemModel]()
                    for data in response.results {
                        let model = NewsItemModel(fromJson: data.1)
                        list.append(model)
                    }
                    return list
                }
                throw errorWithCode(code: .GlobalError(code: response.code, reason: response.message))
        }
        
        return requests.catchError({ (errorType) -> Observable<[NewsItemModel]> in
            let error = errorType as NSError
            throw errorWithCode(code: .GlobalError(code: error.code, reason: error.localizedDescription))
        })
    }
    
    func getSourceList(category: String) -> Observable<[NewsSourceModel]> {
        var url = ApiManager.url_master + headlineSourcesUrl + "&category=" + category
        let request = manager.request( url, method: .get, parameters: [:], encoding: URLEncoding.default)
        let requests = request.rx_JSON()
            .mapJSONResponse()
            .map { response -> [NewsSourceModel] in
                if response.status == "ok" {
                    var list = [NewsSourceModel]()
                    for data in response.results {
                        let model = NewsSourceModel(fromJson: data.1)
                        list.append(model)
                    }
                    return list
                }
                throw errorWithCode(code: .GlobalError(code: response.code, reason: response.message))
        }
        
        return requests.catchError({ (errorType) -> Observable<[NewsSourceModel]> in
            let error = errorType as NSError
            throw errorWithCode(code: .GlobalError(code: error.code, reason: error.localizedDescription))
        })
    }
    
    func getArticleList(sourceId: String, keyword: String = "") -> Observable<[NewsItemModel]> {
        var url = ApiManager.url_master + headlineSourcesUrl + "&sources=" + sourceId
        if keyword != "" {
            url += "&q=" + keyword
        }
        let request = manager.request( url, method: .get, parameters: [:], encoding: URLEncoding.default)
        let requests = request.rx_JSON()
            .mapJSONResponse()
            .map { response -> [NewsItemModel] in
                if response.status == "ok" {
                    var list = [NewsItemModel]()
                    for data in response.results {
                        let model = NewsItemModel(fromJson: data.1)
                        list.append(model)
                    }
                    return list
                }
                throw errorWithCode(code: .GlobalError(code: response.code, reason: response.message))
        }
        
        return requests.catchError({ (errorType) -> Observable<[NewsItemModel]> in
            let error = errorType as NSError
            throw errorWithCode(code: .GlobalError(code: error.code, reason: error.localizedDescription))
        })
    }
}

extension Observable {
    func mapJSONResponse() -> Observable<APIResponse> {
        return map { (item: Element) -> APIResponse in
            guard let json = item as? JSON else {
                return APIResponse(total_results: 0, results: JSON(), code: -1, message: "Cannot convert JSON", status: "Failed")
            }
            var results = json;
            var totalResults = 0;
            var statusCode = 0;
            var statusMessage = "";
            var statusTxt = "ok";
            
            if json["status"].exists() {
                statusTxt = json["status"].stringValue
            }
            
            if json["results"].exists() { // Movie Videos (Trailer)
                results = json["results"]
                
                if json["total_results"].exists(){
                    totalResults = json["total_results"].intValue
                }
            }
            else if json["articles"].exists() { // Movie Videos (Trailer)
                results = json["articles"]
                
                if json["total_results"].exists(){
                    totalResults = json["total_results"].intValue
                }
            }
            else if json["sources"].exists() { // Movie Detail
                results = json["sources"]
            }
            
            
            return APIResponse(total_results: totalResults, results: results, code: statusCode, message: statusMessage, status: statusTxt)
        }
    }
}

struct APIResponse {
    var total_results: Int
    var results: JSON
    
    var code: Int
    var message: String
    var status: String
    
    init(total_results: Int, results: JSON, code: Int, message: String, status: String) {
        self.total_results = total_results
        self.results = results
        
        self.code = code
        self.message = message
        self.status = status
    }
}

class APISessionManager: Session {
    
    override func request(_ convertible: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, interceptor: RequestInterceptor? = nil, requestModifier: Session.RequestModifier? = nil) -> DataRequest {
        
    //override func request(_ convertible: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, interceptor: RequestInterceptor? = nil) -> DataRequest {
        
        print("CONVERTIBLE URL ",convertible)
        var overridedParameters = [String : AnyObject]()
        print("ovverided parameters = \(overridedParameters)")
        if let parameters = parameters {
            overridedParameters = parameters as [String : AnyObject]
        }
        
        var overridedHeaders = HTTPHeaders.init()
        overridedHeaders["Content-Type"] = "application/json"
        overridedHeaders["accept"] = "application/json"
        overridedHeaders["Authorization"] = "Bearer " + ApiManager.apiKey
        
        if let headers = headers {
            for (key, value) in headers.dictionary {
                overridedHeaders[key] = value
            }
        }
        
        #if DEBUG
        print("param: ",overridedParameters)
        print("header: ",overridedHeaders)
        #endif
        
        return super.request(convertible, method: method, parameters: overridedParameters, encoding: encoding, headers: overridedHeaders)
    }
}

extension DataRequest{
    
    func rx_JSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<JSON> {
        let observable = Observable<JSON>.create { observer in
            print("Method : ",self.request?.httpMethod)
            print("Url Request : ",self.request?.url)
            print("Body Request : ",self.request?.httpBody)
            if let method = self.request?.httpMethod, let urlString = self.request?.url {
                print("[\(method)] \(urlString)")
                if let body = self.request?.httpBody {
                    print("request http body = ",NSString(data: body, encoding: String.Encoding.utf8.rawValue) as Any)
                }
            }
            self.responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let value = response.value {
                            let json = JSON(value)
                            print("RESPONSE JSON ",json)
                            if let error = json.error {
                                observer.onError(error)
                            } else {
                                observer.onNext(json)
                                observer.onCompleted()
                            }
                        }
                    } catch {
                        if let error = response.error {
                            print("Error while decoding response: \(error.localizedDescription) from: \(String(data: data, encoding: .utf8))")
                            observer.onError(error)
                        } else {
                            observer.onError(errorWithCode(code: .UnknownError))
                        }
                    }
                case .failure(let error):
                    // Handle as previously error
                    observer.onError(error)
                }
            }
            return Disposables.create {
                self.cancel()
            }
        }
        return Observable.deferred { return observable }
    }
}
