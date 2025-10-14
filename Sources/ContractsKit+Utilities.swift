/**
 * Utilities and helper functions for ContractsKit
 */

import Foundation

// MARK: - Contract Utilities

public struct ContractsKit {
    
    /**
     * Generates a unique contract ID
     */
    public static func generateContractId(prefix: String? = nil) -> String {
        let timestamp = String(Int(Date().timeIntervalSince1970), radix: 36)
        let random = String(Int.random(in: 100000...999999), radix: 36)
        let id = "\(timestamp)-\(random)"
        return prefix.map { "\($0)-\(id)" } ?? id
    }
    
    /**
     * Creates a contract version
     */
    public static func createContractVersion(
        major: Int,
        minor: Int,
        patch: Int,
        prerelease: String? = nil,
        build: String? = nil
    ) -> ContractVersion {
        return ContractVersion(
            major: major,
            minor: minor,
            patch: patch,
            prerelease: prerelease,
            build: build
        )
    }
    
    /**
     * Checks if a contract is deprecated
     */
    public static func isContractDeprecated(_ contract: BaseContract) -> Bool {
        return contract.metadata.deprecated == true
    }
    
    /**
     * Gets contract tags as a comma-separated string
     */
    public static func getContractTagsString(_ contract: BaseContract) -> String {
        return contract.metadata.tags?.joined(separator: ", ") ?? ""
    }
    
    /**
     * Filters contracts by tag
     */
    public static func filterContractsByTag<T: BaseContract>(
        _ contracts: [T],
        tag: String
    ) -> [T] {
        return contracts.filter { contract in
            contract.metadata.tags?.contains(tag) == true
        }
    }
    
    /**
     * Sorts contracts by version (newest first)
     */
    public static func sortContractsByVersion<T: BaseContract>(_ contracts: [T]) -> [T] {
        return contracts.sorted { $0.version > $1.version }
    }
    
    /**
     * Finds the latest version of a contract by ID
     */
    public static func findLatestContractVersion<T: BaseContract>(
        _ contracts: [T],
        contractId: String
    ) -> T? {
        let matchingContracts = contracts.filter { $0.id == contractId }
        guard !matchingContracts.isEmpty else { return nil }
        
        return sortContractsByVersion(matchingContracts).first
    }
    
    /**
     * Updates the updatedAt timestamp of a contract
     */
    public static func updateContractTimestamp<T: BaseContract>(_ contract: T) -> T where T: Equatable {
        // This is a simplified implementation - in practice you'd need to handle
        // the specific contract types individually due to Swift's type system
        return contract
    }
    
    /**
     * Deep clones a contract object
     */
    public static func cloneContract<T: BaseContract>(_ contract: T) throws -> T where T: Codable {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let data = try encoder.encode(contract)
        return try decoder.decode(T.self, from: data)
    }
    
    /**
     * Merges two contract metadata objects
     */
    public static func mergeContractMetadata(
        _ base: ContractMetadata,
        _ override: ContractMetadata
    ) -> ContractMetadata {
        let combinedTags = Set(base.tags ?? []).union(Set(override.tags ?? [])).sorted()
        
        return ContractMetadata(
            author: override.author ?? base.author,
            tags: combinedTags.isEmpty ? nil : Array(combinedTags),
            documentationUrl: override.documentationUrl ?? base.documentationUrl,
            deprecated: override.deprecated ?? base.deprecated,
            deprecationReason: override.deprecationReason ?? base.deprecationReason
        )
    }
    
    // MARK: - Contract Factory Methods
    
    /**
     * Creates a base contract with default values
     */
    public static func createBaseContract(
        id: String,
        name: String,
        version: ContractVersion,
        metadata: ContractMetadata = ContractMetadata()
    ) -> (id: String, name: String, version: ContractVersion, metadata: ContractMetadata, createdAt: Date, updatedAt: Date) {
        let now = Date()
        
        let defaultMetadata = ContractMetadata(
            author: metadata.author ?? "Unknown",
            tags: metadata.tags ?? [],
            documentationUrl: metadata.documentationUrl,
            deprecated: metadata.deprecated ?? false,
            deprecationReason: metadata.deprecationReason
        )
        
        return (
            id: id,
            name: name,
            version: version,
            metadata: defaultMetadata,
            createdAt: now,
            updatedAt: now
        )
    }
    
    /**
     * Creates an event contract
     */
    public static func createEventContract(
        id: String,
        name: String,
        eventType: String,
        payloadSchema: String,
        version: ContractVersion = ContractVersion(major: 1, minor: 0, patch: 0),
        metadata: ContractMetadata = ContractMetadata()
    ) -> EventContract {
        let base = createBaseContract(id: id, name: name, version: version, metadata: metadata)
        
        return EventContract(
            id: base.id,
            version: base.version,
            name: base.name,
            metadata: base.metadata,
            createdAt: base.createdAt,
            updatedAt: base.updatedAt,
            eventType: eventType,
            payload: payloadSchema
        )
    }
    
    /**
     * Creates an API contract
     */
    public static func createApiContract(
        id: String,
        name: String,
        method: HTTPMethod,
        path: String,
        version: ContractVersion = ContractVersion(major: 1, minor: 0, patch: 0),
        metadata: ContractMetadata = ContractMetadata()
    ) -> ApiContract {
        let base = createBaseContract(id: id, name: name, version: version, metadata: metadata)
        
        return ApiContract(
            id: base.id,
            version: base.version,
            name: base.name,
            metadata: base.metadata,
            createdAt: base.createdAt,
            updatedAt: base.updatedAt,
            method: method,
            path: path
        )
    }
    
    /**
     * Creates a data model contract
     */
    public static func createDataModelContract(
        id: String,
        name: String,
        modelName: String,
        fields: [String: FieldDefinition],
        version: ContractVersion = ContractVersion(major: 1, minor: 0, patch: 0),
        metadata: ContractMetadata = ContractMetadata()
    ) -> DataModelContract {
        let base = createBaseContract(id: id, name: name, version: version, metadata: metadata)
        
        return DataModelContract(
            id: base.id,
            version: base.version,
            name: base.name,
            metadata: base.metadata,
            createdAt: base.createdAt,
            updatedAt: base.updatedAt,
            modelName: modelName,
            fields: fields
        )
    }
    
    // MARK: - Validation Utilities
    
    /**
     * Validates a contract ID format
     */
    public static func validateContractId(_ id: String) -> Bool {
        let pattern = "^[a-zA-Z0-9_-]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: id.utf16.count)
        return regex?.firstMatch(in: id, range: range) != nil
    }
    
    /**
     * Validates a semantic version format
     */
    public static func validateSemanticVersion(_ version: String) -> Bool {
        return ContractVersion(from: version) != nil
    }
    
    /**
     * Validates an ISO 8601 date-time string
     */
    public static func validateISODateTime(_ dateTime: String) -> Bool {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateTime) != nil
    }
    
    /**
     * Validates a base contract
     */
    public static func validateBaseContract(_ contract: BaseContract) throws {
        guard validateContractId(contract.id) else {
            throw ContractValidationError(
                path: "id",
                message: "Invalid contract ID format",
                value: contract.id,
                expected: "alphanumeric characters, hyphens, and underscores only"
            )
        }
        
        guard !contract.name.isEmpty else {
            throw ContractValidationError(
                path: "name",
                message: "Contract name cannot be empty",
                value: contract.name
            )
        }
        
        guard contract.name.count <= 100 else {
            throw ContractValidationError(
                path: "name",
                message: "Contract name must be 100 characters or less",
                value: contract.name,
                expected: "maximum 100 characters"
            )
        }
        
        if let description = contract.description, description.count > 500 {
            throw ContractValidationError(
                path: "description",
                message: "Description must be 500 characters or less",
                value: description,
                expected: "maximum 500 characters"
            )
        }
    }
    
    /**
     * Validates an event contract
     */
    public static func validateEventContract(_ contract: EventContract) throws {
        try validateBaseContract(contract)
        
        let eventTypePattern = "^[a-zA-Z0-9._-]+$"
        let regex = try? NSRegularExpression(pattern: eventTypePattern)
        let range = NSRange(location: 0, length: contract.eventType.utf16.count)
        
        guard regex?.firstMatch(in: contract.eventType, range: range) != nil else {
            throw ContractValidationError(
                path: "eventType",
                message: "Invalid event type format",
                value: contract.eventType,
                expected: "alphanumeric characters, dots, underscores, and hyphens only"
            )
        }
    }
    
    /**
     * Validates an API contract
     */
    public static func validateApiContract(_ contract: ApiContract) throws {
        try validateBaseContract(contract)
        
        guard contract.path.hasPrefix("/") else {
            throw ContractValidationError(
                path: "path",
                message: "API path must start with '/'",
                value: contract.path,
                expected: "path starting with '/'"
            )
        }
    }
    
    /**
     * Validates a data model contract
     */
    public static func validateDataModelContract(_ contract: DataModelContract) throws {
        try validateBaseContract(contract)
        
        let modelNamePattern = "^[A-Z][a-zA-Z0-9]*$"
        let regex = try? NSRegularExpression(pattern: modelNamePattern)
        let range = NSRange(location: 0, length: contract.modelName.utf16.count)
        
        guard regex?.firstMatch(in: contract.modelName, range: range) != nil else {
            throw ContractValidationError(
                path: "modelName",
                message: "Model name must be PascalCase",
                value: contract.modelName,
                expected: "PascalCase format (e.g., 'UserModel')"
            )
        }
        
        guard !contract.fields.isEmpty else {
            throw ContractValidationError(
                path: "fields",
                message: "Data model must have at least one field",
                value: contract.fields
            )
        }
    }
}

/**
 * Validation error details
 */
public struct ContractValidationError: Error, LocalizedError {
    public let path: String
    public let message: String
    public let value: Any?
    public let expected: Any?
    
    public init(path: String, message: String, value: Any? = nil, expected: Any? = nil) {
        self.path = path
        self.message = message
        self.value = value
        self.expected = expected
    }
    
    public var errorDescription: String? {
        return "\(path): \(message)"
    }
}