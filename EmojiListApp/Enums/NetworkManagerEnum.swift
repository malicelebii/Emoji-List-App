//
//  NetworkManagerEnum.swift
//  EmojiListApp
//
//  Created by Mehmet Ali ÇELEBİ on 5.06.2024.
//

import Foundation

enum NetworkErrorEnum: String, Error {
    case badURL = "Url is not valid"
    case badRequest = "Request invalid"
    case decodeError = "Data cannot be decoded"
}
