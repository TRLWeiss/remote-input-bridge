import Foundation

enum VoiceMetrics {
    static func write(id: UUID, text: String, began: Date, duration: TimeInterval) {
        let count = text.filter { !$0.isWhitespace }.count
        guard count > 0 else { return }
        let folder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support/InputPulse/voice-events", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
            let event: [String: Any] = ["id": id.uuidString, "start": began.timeIntervalSince1970, "duration": duration, "characters": count, "source": "bridge"]
            let data = try JSONSerialization.data(withJSONObject: event, options: [.sortedKeys])
            let path = folder.appendingPathComponent(id.uuidString + ".json")
            try data.write(to: path, options: .atomic)
            try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: path.path)
        } catch { NSLog("InputPulse aggregate write failed: %@", error.localizedDescription) }
    }
}
