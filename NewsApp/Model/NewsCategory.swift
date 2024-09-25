//
//  NewsCategory.swift
//  NewsApp
//
//  Created by Mac on 25/09/24.
//

import Foundation

public enum NewsCategory{
    case all
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

extension NewsCategory {
    var categoryName: String {
        switch self {
        case .all:
            return ""
        case .business:
            return "business"
        case .entertainment:
            return "entertainment"
        case .general:
            return "general"
        case .health:
            return "health"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .technology:
            return "technology"
        }
    }
    
    var categoryTitle: String {
        switch self {
        case .all:
            return "All"
        case .business:
            return "Business"
        case .entertainment:
            return "Entertainment"
        case .general:
            return "General"
        case .health:
            return "Health"
        case .science:
            return "Science"
        case .sports:
            return "Sports"
        case .technology:
            return "Technology"
        }
    }
}
