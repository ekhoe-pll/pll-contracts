/**
 * ContractsKit - Shared contracts and schemas for PLL applications
 * 
 * This package provides type definitions and validation schemas
 * that are shared between Swift and TypeScript/JavaScript applications.
 */

import Foundation

// MARK: - Base Contract Types

/**
 * Base protocol that all contracts must implement
 */
public protocol BaseContract: Codable {
    /// Unique identifier for the contract
    var id: String { get }
    /// Version of the contract
    var version: ContractVersion { get }
    /// Human-readable name
    var name: String { get }
    /// Contract description
    var description: String? { get }
    /// Metadata about the contract
    var metadata: ContractMetadata { get }
    /// Timestamp when contract was created
    var createdAt: Date { get }
    /// Timestamp when contract was last updated
    var updatedAt: Date { get }
}

/**
 * Semantic version representation
 */
public struct ContractVersion: Codable, Equatable, Comparable {
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let prerelease: String?
    public let build: String?
    
    public init(major: Int, minor: Int, patch: Int, prerelease: String? = nil, build: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.prerelease = prerelease
        self.build = build
    }
    
    public static func < (lhs: ContractVersion, rhs: ContractVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        if lhs.patch != rhs.patch { return lhs.patch < rhs.patch }
        
        // Handle prerelease comparison
        switch (lhs.prerelease, rhs.prerelease) {
        case (nil, nil): return false
        case (nil, _): return false  // stable version is greater than prerelease
        case (_, nil): return true   // prerelease is less than stable
        case (let lhsPrerelease?, let rhsPrerelease?):
            return lhsPrerelease.compare(rhsPrerelease, options: .numeric) == .orderedAscending
        }
    }
    
    /// Creates a version from a semantic version string
    public init?(from semanticVersion: String) {
        let pattern = #"^(\d+)\.(\d+)\.(\d+)(?:-([^+]+))?(?:\+(.+))?$"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: semanticVersion.utf16.count)
        
        guard let match = regex?.firstMatch(in: semanticVersion, range: range),
              let majorRange = Range(match.range(at: 1), in: semanticVersion),
              let minorRange = Range(match.range(at: 2), in: semanticVersion),
              let patchRange = Range(match.range(at: 3), in: semanticVersion) else {
            return nil
        }
        
        self.major = Int(semanticVersion[majorRange]) ?? 0
        self.minor = Int(semanticVersion[minorRange]) ?? 0
        self.patch = Int(semanticVersion[patchRange]) ?? 0
        
        if match.range(at: 4).location != NSNotFound,
           let prereleaseRange = Range(match.range(at: 4), in: semanticVersion) {
            self.prerelease = String(semanticVersion[prereleaseRange])
        } else {
            self.prerelease = nil
        }
        
        if match.range(at: 5).location != NSNotFound,
           let buildRange = Range(match.range(at: 5), in: semanticVersion) {
            self.build = String(semanticVersion[buildRange])
        } else {
            self.build = nil
        }
    }
    
    /// Returns the semantic version string representation
    public var semanticVersion: String {
        var version = "\(major).\(minor).\(patch)"
        if let prerelease = prerelease {
            version += "-\(prerelease)"
        }
        if let build = build {
            version += "+\(build)"
        }
        return version
    }
}

/**
 * Additional metadata for contracts
 */
public struct ContractMetadata: Codable, Equatable {
    /// Author of the contract
    public let author: String?
    /// Tags for categorization
    public let tags: [String]?
    /// External documentation URL
    public let documentationUrl: String?
    /// Deprecation information
    public let deprecated: Bool?
    /// Deprecation reason if deprecated
    public let deprecationReason: String?
    
    public init(
        author: String? = nil,
        tags: [String]? = nil,
        documentationUrl: String? = nil,
        deprecated: Bool? = nil,
        deprecationReason: String? = nil
    ) {
        self.author = author
        self.tags = tags
        self.documentationUrl = documentationUrl
        self.deprecated = deprecated
        self.deprecationReason = deprecationReason
    }
}

// MARK: - Event Contract Types

/**
 * Event priority levels
 */
public enum EventPriority: String, Codable, CaseIterable {
    case low = "low"
    case normal = "normal"
    case high = "high"
    case critical = "critical"
}

/**
 * Event-specific metadata
 */
public struct EventMetadata: Codable, Equatable {
    /// Event priority
    public let priority: EventPriority?
    /// Event category
    public let category: String?
    /// Whether event should be persisted
    public let persistent: Bool?
    /// TTL in milliseconds
    public let ttl: Int?
    
    public init(
        priority: EventPriority? = nil,
        category: String? = nil,
        persistent: Bool? = nil,
        ttl: Int? = nil
    ) {
        self.priority = priority
        self.category = category
        self.persistent = persistent
        self.ttl = ttl
    }
}

/**
 * Generic event contract structure
 */
public struct EventContract: BaseContract {
    public let id: String
    public let version: ContractVersion
    public let name: String
    public let description: String?
    public let metadata: ContractMetadata
    public let createdAt: Date
    public let updatedAt: Date
    /// Event type identifier
    public let eventType: String
    /// Event payload schema (as JSON string for Codable compliance)
    public let payload: String
    /// Event metadata
    public let eventMetadata: EventMetadata?
    
    public init(
        id: String,
        version: ContractVersion,
        name: String,
        description: String? = nil,
        metadata: ContractMetadata,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        eventType: String,
        payload: String,
        eventMetadata: EventMetadata? = nil
    ) {
        self.id = id
        self.version = version
        self.name = name
        self.description = description
        self.metadata = metadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.eventType = eventType
        self.payload = payload
        self.eventMetadata = eventMetadata
    }
}

// MARK: - API Contract Types

/**
 * HTTP methods
 */
public enum HTTPMethod: String, Codable, CaseIterable {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

/**
 * Authentication types
 */
public enum AuthType: String, Codable, CaseIterable {
    case none = "none"
    case bearer = "bearer"
    case basic = "basic"
    case apiKey = "api-key"
    case oauth2 = "oauth2"
}

/**
 * Authentication requirements
 */
public struct AuthRequirements: Codable, Equatable {
    /// Required authentication type
    public let type: AuthType
    /// Required scopes/permissions
    public let scopes: [String]?
    /// Whether auth is optional
    public let optional: Bool?
    
    public init(
        type: AuthType,
        scopes: [String]? = nil,
        optional: Bool? = nil
    ) {
        self.type = type
        self.scopes = scopes
        self.optional = optional
    }
}

/**
 * API contract structure
 */
public struct ApiContract: BaseContract {
    public let id: String
    public let version: ContractVersion
    public let name: String
    public let description: String?
    public let metadata: ContractMetadata
    public let createdAt: Date
    public let updatedAt: Date
    /// HTTP method
    public let method: HTTPMethod
    /// API endpoint path
    public let path: String
    /// Request schema (as JSON string for Codable compliance)
    public let requestSchema: String?
    /// Response schema (as JSON string for Codable compliance)
    public let responseSchema: String?
    /// Authentication requirements
    public let auth: AuthRequirements?
    
    public init(
        id: String,
        version: ContractVersion,
        name: String,
        description: String? = nil,
        metadata: ContractMetadata,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        method: HTTPMethod,
        path: String,
        requestSchema: String? = nil,
        responseSchema: String? = nil,
        auth: AuthRequirements? = nil
    ) {
        self.id = id
        self.version = version
        self.name = name
        self.description = description
        self.metadata = metadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.method = method
        self.path = path
        self.requestSchema = requestSchema
        self.responseSchema = responseSchema
        self.auth = auth
    }
}

// MARK: - Data Model Contract Types

/**
 * Validation rule types
 */
public enum ValidationRuleType: String, Codable, CaseIterable {
    case min = "min"
    case max = "max"
    case pattern = "pattern"
    case `enum` = "enum"
    case custom = "custom"
}

/**
 * Validation rule
 */
public struct ValidationRule: Codable, Equatable {
    /// Rule type
    public let type: ValidationRuleType
    /// Rule value
    public let value: String
    /// Error message
    public let message: String?
    
    public init(
        type: ValidationRuleType,
        value: String,
        message: String? = nil
    ) {
        self.type = type
        self.value = value
        self.message = message
    }
}

/**
 * Field definition in a data model
 */
public struct FieldDefinition: Codable, Equatable {
    /// Field type
    public let type: String
    /// Whether field is required
    public let required: Bool?
    /// Default value
    public let defaultValue: String?
    /// Field description
    public let description: String?
    /// Validation rules
    public let validation: [ValidationRule]?
    
    public init(
        type: String,
        required: Bool? = nil,
        defaultValue: String? = nil,
        description: String? = nil,
        validation: [ValidationRule]? = nil
    ) {
        self.type = type
        self.required = required
        self.defaultValue = defaultValue
        self.description = description
        self.validation = validation
    }
}

/**
 * Cascade behaviors
 */
public enum CascadeBehavior: String, Codable, CaseIterable {
    case cascade = "cascade"
    case setNull = "set-null"
    case restrict = "restrict"
}

/**
 * Foreign key relationship
 */
public struct ForeignKey: Codable, Equatable {
    /// Local field
    public let field: String
    /// Referenced model
    public let references: String
    /// Referenced field
    public let referencedField: String
    /// Cascade behavior on delete
    public let onDelete: CascadeBehavior?
    /// Cascade behavior on update
    public let onUpdate: CascadeBehavior?
    
    public init(
        field: String,
        references: String,
        referencedField: String,
        onDelete: CascadeBehavior? = nil,
        onUpdate: CascadeBehavior? = nil
    ) {
        self.field = field
        self.references = references
        self.referencedField = referencedField
        self.onDelete = onDelete
        self.onUpdate = onUpdate
    }
}

/**
 * Model constraints
 */
public struct ModelConstraints: Codable, Equatable {
    /// Unique fields
    public let unique: [String]?
    /// Indexed fields
    public let indexes: [String]?
    /// Foreign key relationships
    public let foreignKeys: [ForeignKey]?
    
    public init(
        unique: [String]? = nil,
        indexes: [String]? = nil,
        foreignKeys: [ForeignKey]? = nil
    ) {
        self.unique = unique
        self.indexes = indexes
        self.foreignKeys = foreignKeys
    }
}

/**
 * Data model contract
 */
public struct DataModelContract: BaseContract, Equatable {
    public let id: String
    public let version: ContractVersion
    public let name: String
    public let description: String?
    public let metadata: ContractMetadata
    public let createdAt: Date
    public let updatedAt: Date
    /// Model name
    public let modelName: String
    /// Model fields
    public let fields: [String: FieldDefinition]
    /// Model constraints
    public let constraints: ModelConstraints?
    
    public init(
        id: String,
        version: ContractVersion,
        name: String,
        description: String? = nil,
        metadata: ContractMetadata,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        modelName: String,
        fields: [String: FieldDefinition],
        constraints: ModelConstraints? = nil
    ) {
        self.id = id
        self.version = version
        self.name = name
        self.description = description
        self.metadata = metadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.modelName = modelName
        self.fields = fields
        self.constraints = constraints
    }
}
