//
//  Debouncer.swift
//  ThmanyahTestApp
//
//  Created by Nour-Eddine Legragui  on 10/3/2026.
//

import Foundation

actor Debouncer {
    private var task: Task<Void, Never>?
    private let duration: Duration

    init(duration: Duration = .milliseconds(200)) {
        self.duration = duration
    }

    func debounce(action: @escaping () async -> Void) {
        task?.cancel()

        task = Task {
            do {
                try await Task.sleep(for: duration)
                guard !Task.isCancelled else { return }
                await action()
            } catch {
                // ignored
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
