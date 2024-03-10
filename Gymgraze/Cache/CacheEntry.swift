//
//  CacheEntry.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 10/03/2024.
//

import Foundation

final class CacheEntry<V> {
    
    let key: String
    let value: V
    let expirationTimestamp: Date
    
    init(key: String, value: V, expirationTimestamp: Date) {
        self.key = key
        self.value = value
        self.expirationTimestamp = expirationTimestamp
    }
    
    var isExpired: Bool {
        return expirationTimestamp < Date()
    }
}
