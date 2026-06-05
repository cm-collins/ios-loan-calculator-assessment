import Foundation

enum SavedLoanRepositoryError: LocalizedError {
    case failedToCreateStorageURL
    case failedToEncode
    case failedToSave
    case failedToRead

    var errorDescription: String? {
        switch self {
        case .failedToCreateStorageURL:
            return "Could not create storage location."
        case .failedToEncode:
            return "Could not encode saved loans."
        case .failedToSave:
            return "Could not save loan."
        case .failedToRead:
            return "Could not read saved loans."
        }
    }
}

final class SavedLoanRepository {
    static let shared = SavedLoanRepository()

    private let fileName = "saved-loans.json"
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func save(_ entity: SavedLoanEntity) throws {
        var loans = try fetchAll()

        loans.removeAll { $0.id == entity.id }
        loans.insert(entity, at: 0)

        try write(loans)
    }

    func fetchAll() throws -> [SavedLoanEntity] {
        let url = try storageURL()

        guard fileManager.fileExists(atPath: url.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([SavedLoanEntity].self, from: data)
        } catch {
            throw SavedLoanRepositoryError.failedToRead
        }
    }

    func fetchLatest() throws -> SavedLoanEntity? {
        try fetchAll().first
    }

    func deleteAll() throws {
        try write([])
    }

    private func write(_ loans: [SavedLoanEntity]) throws {
        do {
            let data = try JSONEncoder().encode(loans)
            let url = try storageURL()

            try data.write(to: url, options: [.atomic])
        } catch {
            throw SavedLoanRepositoryError.failedToSave
        }
    }

    private func storageURL() throws -> URL {
        guard let documentsDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw SavedLoanRepositoryError.failedToCreateStorageURL
        }

        return documentsDirectory.appendingPathComponent(fileName)
    }
}
