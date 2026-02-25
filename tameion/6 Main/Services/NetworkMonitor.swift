//
//  NetworkMonitor.swift
//  tameion
//
//  Created by Shola Ventures on 2/6/26.
//
import Network
import Combine

@MainActor
final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    @Published var isConnected = true
    @Published var connectionType: NWInterface.InterfaceType?

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private init() {
        startMonitoring()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                guard let self = self else { return }

                let previousState = self.isConnected
                self.isConnected = path.status == .satisfied
                self.connectionType = path.availableInterfaces.first?.type

                print("🔍 Network Monitor Update:")
                print("  - Previous: \(previousState)")
                print("  - Current: \(self.isConnected)")
                print("  - Path status: \(path.status)")
                print("  - Available interfaces: \(path.availableInterfaces)")


                if path.status == .satisfied {
                    print("🌐 Network: Connected")
                } else {
                    print("📵 Network: Disconnected")

                    try? await Task.sleep(for: .seconds(1))
                }
            }
        }

        monitor.start(queue: queue)
    }

    func recheckConnection() -> Bool {
        let currentPath = monitor.currentPath
        let isCurrentlyConnected = currentPath.status == .satisfied

        print("🔍 Recheck - Path status: \(currentPath.status), Connected: \(isCurrentlyConnected)")

        // Update published property if it changed
        if isConnected != isCurrentlyConnected {
            isConnected = isCurrentlyConnected
        }

        return isCurrentlyConnected
    }

    nonisolated func stopMonitoring() {
        monitor.cancel()
    }

    deinit {
        stopMonitoring()
    }
}
