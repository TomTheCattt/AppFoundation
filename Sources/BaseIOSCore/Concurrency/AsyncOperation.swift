//
//  AsyncOperation.swift
//  BaseIOSApp
//

import Foundation

class AsyncOperation: Operation, @unchecked Sendable {
    private enum State {
        case ready, executing, finished
    }

    private var state: State = .ready {
        willSet {
            willChangeValue(forKey: "isExecuting")
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
            didChangeValue(forKey: "isFinished")
        }
    }

    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool { state == .executing }
    override var isFinished: Bool { state == .finished }

    override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        state = .executing
        main()
    }

    func finish() {
        state = .finished
    }
}
