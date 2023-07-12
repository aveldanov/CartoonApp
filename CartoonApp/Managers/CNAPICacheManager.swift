//
//  CNAPICacheManager.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/7/23.
//

import Foundation


/// Manage in-memory session scoped API caches
final class CNAPICacheManager {

    // API URL: Data

    private var cacheDictionary: [CNEndpoint: NSCache<NSString, NSData>] = [:]

    private var cache = NSCache<NSString, NSData>()

    init() {
        setupCache()
    }

    // MARK: - Public methods

    public func setCache(for endpoint: CNEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }

        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }

    public func getCache(for endpoint: CNEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }

        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }

    // MARK: - Private methods

    private func setupCache() {
        CNEndpoint.allCases.forEach({ endpoint in
            // new cache object for each type of endpoint
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
}
