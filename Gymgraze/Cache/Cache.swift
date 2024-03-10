//
//  Cache.swift
//  Gymgraze
//
//  Created by Ivan Branimir Skoric on 10/03/2024.
//

import Foundation

actor InMemoryCache<V> {
    
    private let cache: NSCache<NSString, CacheEntry<V>> = .init()
    private let expirationInterval: TimeInterval
    
    init(expirationInterval: TimeInterval = 2 * 60) {
        self.expirationInterval = expirationInterval
    }
    
    func removeAllValues() {
        cache.removeAllObjects()
    }
    
    func removeValue(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func setValue(_ value: V?, forKey key: String) {
        if let value = value {
            let expirationTimestamp = Date().addingTimeInterval(expirationInterval)
            let cacheEntry = CacheEntry(key: key, value: value, expirationTimestamp: expirationTimestamp)
            cache.setObject(cacheEntry, forKey: key as NSString)
        } else {
            removeValue(forKey: key)
        }
    }
    
    func value(forKey key: String) -> V? {
        guard let cacheEntry = cache.object(forKey: key as NSString) else {
            return nil
        }
        
        guard cacheEntry.expirationTimestamp > Date() else {
            removeValue(forKey: key)
            return nil
        }
        
        return cacheEntry.value
    }
}
