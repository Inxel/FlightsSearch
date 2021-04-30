//
//  Debouncer.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 30.04.2021.
//

import Foundation

struct Debouncer {
    
    // MARK: - Properties

    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem = .init(block: {})
    private var interval: TimeInterval
    
    // MARK: - Init

    init(queue: DispatchQueue = .main, seconds: TimeInterval) {
        self.queue = queue
        interval = seconds
    }
    
    // MARK: - Public
    
    mutating func debounce(action: @escaping Handler) {
        cancel()
        workItem = DispatchWorkItem(block: { action() })
        queue.asyncAfter(deadline: .now() + interval, execute: workItem)
    }
    
    mutating func cancel() {
        workItem.cancel()
    }
    
}
