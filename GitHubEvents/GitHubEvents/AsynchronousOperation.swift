//
//  AsynchronousOperation.swift
//  GitHubEvents
//
//  Created by Liza Kryshkovskaya on 12.11.21.
//

import Foundation

open class AsynchronousOperation: Operation {

//    let queue = DispatchQueue(label: "test")

    public override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    public override var isAsynchronous: Bool {
        return true
    }
    
    public override var isExecuting: Bool {
        return state == .executing
    }
    
    public override var isFinished: Bool {
        return state == .finished
    }
    
    public override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    open override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            print("main executing")
            state = .executing
        }
    }
    
    public func finish() {
        state = .finished
    }
    
    // MARK: - State management
    public enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    /// Thread-safe computed state value
    public var state: State {
        get {
            stateQueue.sync {
               return stateStore
            }
        }
        set {
           let oldValue = state
           willChangeValue(forKey: state.keyPath)
           willChangeValue(forKey: newValue.keyPath)
           stateQueue.sync(flags: .barrier) {
               stateStore = newValue
           }
           didChangeValue(forKey: state.keyPath)
           didChangeValue(forKey: oldValue.keyPath)
        }
    }
    private let stateQueue = DispatchQueue(label: "AsynchronousOperation State Queue", attributes: .concurrent)
    /// Non thread-safe state storage, use only with locks
        private var stateStore: State = .ready
}
