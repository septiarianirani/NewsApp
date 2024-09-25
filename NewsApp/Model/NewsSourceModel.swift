//
//  NewsSourceModel.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import Foundation
import SwiftyJSON

class NewsSourceModel : NSObject, NSCoding{

    var id : String!
    var name : String!
    var descriptionSource : String!
    var url : String!
    var category : String!
    var language : String!
    var country : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        name = json["name"].stringValue
        descriptionSource = json["description"].stringValue
        url = json["url"].stringValue
        category = json["category"].stringValue
        language = json["language"].stringValue
        country = json["country"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if descriptionSource != nil{
            dictionary["description"] = descriptionSource
        }
        if url != nil{
            dictionary["url"] = url
        }
        if category != nil{
            dictionary["category"] = category
        }
        if language != nil{
            dictionary["language"] = language
        }
        if country != nil{
            dictionary["country"] = country
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        descriptionSource = aDecoder.decodeObject(forKey: "description") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        category = aDecoder.decodeObject(forKey: "category") as? String
        language = aDecoder.decodeObject(forKey: "language") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if descriptionSource != nil{
            aCoder.encode(descriptionSource, forKey: "description")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if language != nil{
            aCoder.encode(language, forKey: "language")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
    }

}
