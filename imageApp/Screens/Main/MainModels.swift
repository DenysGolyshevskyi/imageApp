//
//  MainModels.swift
//  giphyApp
//
//  Created by Denys on 21.01.2023.
//

import UIKit

enum Main {
    struct Request {
        var searchText: String
        var pagination: PaginationModel
    }
    
    struct ResponseModel: Decodable {
        let data: [Datum]
        let pagination: Pagination
    }
    
    struct ImageViewModel {
        let imageURL: String?
        let imageName: String?
    }
}

// MARK: - Datum
struct Datum: Decodable {
    let id: String
    let images: Images

    enum CodingKeys: String, CodingKey {
        case id
        case images
    }
}

// MARK: - Images
struct Images: Decodable {
    let original: FixedHeight

    enum CodingKeys: String, CodingKey {
        case original
    }
}

// MARK: - FixedHeight
struct FixedHeight: Decodable {
    let height, width, size: String
    let url: String
    let mp4Size: String?
    let mp4: String?
    let webpSize: String
    let webp: String
    let frames, hash: String?

    enum CodingKeys: String, CodingKey {
        case height, width, size, url
        case mp4Size = "mp4_size"
        case mp4
        case webpSize = "webp_size"
        case webp, frames, hash
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalCount, count, offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}
