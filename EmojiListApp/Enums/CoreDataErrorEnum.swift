//
//  CoreDataErrorEnum.swift
//  EmojiListApp
//
//  Created by Mehmet Ali ÇELEBİ on 7.06.2024.
//

import Foundation

enum CoreDataErrorEnum: Error {
    case loadStoreError(String)
    case saveError
    case fetchError
    case deleteError
    
    var errorMessage: String {
        switch self {
        case .loadStoreError(let message):
            return message
        case .saveError:
            return "Couldn't save successfully"
        case .fetchError:
            return "Cannot find the data"
        case .deleteError:
            return "Couldn't delete successfully"
        }
    }
}
