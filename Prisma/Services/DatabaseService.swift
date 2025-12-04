import SwiftData
class SwiftDataContainer {
    static let container: ModelContainer = {
        let schema: Schema = Schema([
            AestheticModel.self,
            ImageModel.self,
        ])

        let modelConfiguration: ModelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Erro ao criar o ModelContainer: \(error)")
        }
    }()
}
