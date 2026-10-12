import Foundation
import SwiftData

enum SwiftDataContainer {
    static let container: ModelContainer = {
        ensureApplicationSupportDirectoryExists()

        let schema = Schema([AestheticModel.self, ImageModel.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            let description = "\(error) \(error.localizedDescription)".lowercased()
            let schemaMismatch = description.contains("incompatible")
                || description.contains("migration")
                || description.contains("schema")

            if schemaMismatch {
                print("SwiftData store was incompatible and will be recreated: \(error)")
                destroyStore(at: configuration.url)
                do {
                    return try ModelContainer(for: schema, configurations: [configuration])
                } catch {
                    fatalError("Failed to create ModelContainer: \(error)")
                }
            }

            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    static let previewContainer: ModelContainer = {
        let schema = Schema([AestheticModel.self, ImageModel.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create preview ModelContainer: \(error)")
        }
    }()

    private static func ensureApplicationSupportDirectoryExists() {
        let url = URL.applicationSupportDirectory
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

    private static func destroyStore(at url: URL) {
        let fileManager = FileManager.default
        let basePath = url.path
        for path in [basePath, basePath + "-shm", basePath + "-wal"] {
            try? fileManager.removeItem(atPath: path)
        }
    }
}
