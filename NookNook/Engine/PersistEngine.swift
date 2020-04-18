//
//  PersistEngine.swift
//  NookNook
//
//  Created by Kevin Laminto on 17/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation

struct PersistEngine {
    
    private var items: [Item] = []
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("collection")
            
            if let data = try? Data(contentsOf: filePath) {
                decoder.dataDecodingStrategy = .base64
                items = try decoder.decode([Item].self, from: data)
                
                if items.contains(static_item) {
                    items.removeAll(where: {$0 == static_item})
                }
//                items.append(static_item2)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func save() {
        do {
            let data = try encoder.encode(items)
            try data.write(to: filePath, options: .atomicWrite)
        } catch let error {
            print("Error while saving collection: \(error.localizedDescription)")
        }
        encoder.dataEncodingStrategy = .base64
    }
    
    func read() {
    }
}
