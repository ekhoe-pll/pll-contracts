/**
 * Tests for ContractsKit
 */

import XCTest
@testable import ContractsKit

final class ContractsKitTests: XCTestCase {
    
    // MARK: - ContractVersion Tests
    
    func testContractVersionCreation() {
        let version = ContractVersion(major: 1, minor: 2, patch: 3)
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
        XCTAssertNil(version.prerelease)
        XCTAssertNil(version.build)
    }
    
    func testContractVersionWithPrereleaseAndBuild() {
        let version = ContractVersion(
            major: 1,
            minor: 2,
            patch: 3,
            prerelease: "alpha.1",
            build: "build.123"
        )
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
        XCTAssertEqual(version.prerelease, "alpha.1")
        XCTAssertEqual(version.build, "build.123")
    }
    
    func testContractVersionFromSemanticVersion() {
        let version = ContractVersion(from: "1.2.3-alpha.1+build.123")
        XCTAssertNotNil(version)
        XCTAssertEqual(version?.major, 1)
        XCTAssertEqual(version?.minor, 2)
        XCTAssertEqual(version?.patch, 3)
        XCTAssertEqual(version?.prerelease, "alpha.1")
        XCTAssertEqual(version?.build, "build.123")
    }
    
    func testContractVersionSemanticVersionString() {
        let version = ContractVersion(
            major: 1,
            minor: 2,
            patch: 3,
            prerelease: "alpha.1",
            build: "build.123"
        )
        XCTAssertEqual(version.semanticVersion, "1.2.3-alpha.1+build.123")
    }
    
    func testContractVersionComparison() {
        let v1_0_0 = ContractVersion(major: 1, minor: 0, patch: 0)
        let v1_0_1 = ContractVersion(major: 1, minor: 0, patch: 1)
        let v1_1_0 = ContractVersion(major: 1, minor: 1, patch: 0)
        let v2_0_0 = ContractVersion(major: 2, minor: 0, patch: 0)
        
        XCTAssertTrue(v1_0_0 < v1_0_1)
        XCTAssertTrue(v1_0_1 < v1_1_0)
        XCTAssertTrue(v1_1_0 < v2_0_0)
        XCTAssertFalse(v1_0_0 < v1_0_0)
    }
    
    func testContractVersionPrereleaseComparison() {
        let stable = ContractVersion(major: 1, minor: 0, patch: 0)
        let prerelease = ContractVersion(major: 1, minor: 0, patch: 0, prerelease: "alpha.1")
        
        XCTAssertTrue(prerelease < stable)
        XCTAssertFalse(stable < prerelease)
    }
    
    // MARK: - ContractMetadata Tests
    
    func testContractMetadataCreation() {
        let metadata = ContractMetadata(
            author: "Test Author",
            tags: ["test", "example"],
            documentationUrl: "https://example.com/docs",
            deprecated: false,
            deprecationReason: nil
        )
        
        XCTAssertEqual(metadata.author, "Test Author")
        XCTAssertEqual(metadata.tags, ["test", "example"])
        XCTAssertEqual(metadata.documentationUrl, "https://example.com/docs")
        XCTAssertEqual(metadata.deprecated, false)
        XCTAssertNil(metadata.deprecationReason)
    }
    
    // MARK: - EventContract Tests
    
    func testEventContractCreation() {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        let payload = ["userId": "string", "timestamp": "number"]
        
        let contract = EventContract(
            id: "test-event",
            version: version,
            name: "Test Event",
            description: "A test event contract",
            metadata: metadata,
            eventType: "user.created",
            payload: payload
        )
        
        XCTAssertEqual(contract.id, "test-event")
        XCTAssertEqual(contract.name, "Test Event")
        XCTAssertEqual(contract.description, "A test event contract")
        XCTAssertEqual(contract.eventType, "user.created")
        XCTAssertEqual(contract.payload["userId"] as? String, "string")
    }
    
    // MARK: - ApiContract Tests
    
    func testApiContractCreation() {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        let auth = AuthRequirements(type: .bearer, scopes: ["read", "write"])
        
        let contract = ApiContract(
            id: "test-api",
            version: version,
            name: "Test API",
            description: "A test API contract",
            metadata: metadata,
            method: .POST,
            path: "/api/users",
            requestSchema: ["name": "string", "email": "string"],
            responseSchema: ["id": "string", "created": "boolean"],
            auth: auth
        )
        
        XCTAssertEqual(contract.id, "test-api")
        XCTAssertEqual(contract.name, "Test API")
        XCTAssertEqual(contract.method, .POST)
        XCTAssertEqual(contract.path, "/api/users")
        XCTAssertEqual(contract.auth?.type, .bearer)
        XCTAssertEqual(contract.auth?.scopes, ["read", "write"])
    }
    
    // MARK: - DataModelContract Tests
    
    func testDataModelContractCreation() {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        
        let fields: [String: FieldDefinition] = [
            "id": FieldDefinition(type: "string", required: true),
            "name": FieldDefinition(type: "string", required: true),
            "email": FieldDefinition(type: "string", required: false)
        ]
        
        let constraints = ModelConstraints(
            unique: ["email"],
            indexes: ["name"],
            foreignKeys: []
        )
        
        let contract = DataModelContract(
            id: "test-model",
            version: version,
            name: "Test Model",
            description: "A test data model contract",
            metadata: metadata,
            modelName: "User",
            fields: fields,
            constraints: constraints
        )
        
        XCTAssertEqual(contract.id, "test-model")
        XCTAssertEqual(contract.name, "Test Model")
        XCTAssertEqual(contract.modelName, "User")
        XCTAssertEqual(contract.fields.count, 3)
        XCTAssertTrue(contract.fields["id"]?.required == true)
        XCTAssertEqual(contract.constraints?.unique, ["email"])
    }
    
    // MARK: - Utility Function Tests
    
    func testGenerateContractId() {
        let id1 = ContractsKit.generateContractId()
        let id2 = ContractsKit.generateContractId()
        
        XCTAssertFalse(id1.isEmpty)
        XCTAssertFalse(id2.isEmpty)
        XCTAssertNotEqual(id1, id2)
        
        let prefixedId = ContractsKit.generateContractId(prefix: "test")
        XCTAssertTrue(prefixedId.hasPrefix("test-"))
    }
    
    func testValidateContractId() {
        XCTAssertTrue(ContractsKit.validateContractId("valid-id"))
        XCTAssertTrue(ContractsKit.validateContractId("valid_id"))
        XCTAssertTrue(ContractsKit.validateContractId("valid123"))
        XCTAssertFalse(ContractsKit.validateContractId("invalid id"))
        XCTAssertFalse(ContractsKit.validateContractId("invalid@id"))
        XCTAssertFalse(ContractsKit.validateContractId(""))
    }
    
    func testValidateSemanticVersion() {
        XCTAssertTrue(ContractsKit.validateSemanticVersion("1.0.0"))
        XCTAssertTrue(ContractsKit.validateSemanticVersion("1.2.3-alpha.1"))
        XCTAssertTrue(ContractsKit.validateSemanticVersion("1.2.3+build.123"))
        XCTAssertTrue(ContractsKit.validateSemanticVersion("1.2.3-alpha.1+build.123"))
        XCTAssertFalse(ContractsKit.validateSemanticVersion("1.0"))
        XCTAssertFalse(ContractsKit.validateSemanticVersion("invalid"))
        XCTAssertFalse(ContractsKit.validateSemanticVersion(""))
    }
    
    func testValidateISODateTime() {
        XCTAssertTrue(ContractsKit.validateISODateTime("2023-01-01T12:00:00Z"))
        XCTAssertTrue(ContractsKit.validateISODateTime("2023-01-01T12:00:00.000Z"))
        XCTAssertFalse(ContractsKit.validateISODateTime("2023-01-01"))
        XCTAssertFalse(ContractsKit.validateISODateTime("invalid"))
        XCTAssertFalse(ContractsKit.validateISODateTime(""))
    }
    
    // MARK: - Validation Tests
    
    func testValidateBaseContract() throws {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        
        let validContract = EventContract(
            id: "valid-id",
            version: version,
            name: "Valid Contract",
            metadata: metadata,
            eventType: "test.event",
            payload: [:]
        )
        
        XCTAssertNoThrow(try ContractsKit.validateBaseContract(validContract))
    }
    
    func testValidateBaseContractWithInvalidId() throws {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        
        let invalidContract = EventContract(
            id: "invalid id",
            version: version,
            name: "Invalid Contract",
            metadata: metadata,
            eventType: "test.event",
            payload: [:]
        )
        
        XCTAssertThrowsError(try ContractsKit.validateBaseContract(invalidContract)) { error in
            if let validationError = error as? ContractValidationError {
                XCTAssertEqual(validationError.path, "id")
                XCTAssertTrue(validationError.message.contains("Invalid contract ID"))
            } else {
                XCTFail("Expected ContractValidationError")
            }
        }
    }
    
    func testValidateEventContract() throws {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        
        let validContract = EventContract(
            id: "valid-id",
            version: version,
            name: "Valid Event Contract",
            metadata: metadata,
            eventType: "user.created",
            payload: [:]
        )
        
        XCTAssertNoThrow(try ContractsKit.validateEventContract(validContract))
    }
    
    func testValidateEventContractWithInvalidEventType() throws {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        
        let invalidContract = EventContract(
            id: "valid-id",
            version: version,
            name: "Invalid Event Contract",
            metadata: metadata,
            eventType: "invalid event type",
            payload: [:]
        )
        
        XCTAssertThrowsError(try ContractsKit.validateEventContract(invalidContract)) { error in
            if let validationError = error as? ContractValidationError {
                XCTAssertEqual(validationError.path, "eventType")
                XCTAssertTrue(validationError.message.contains("Invalid event type"))
            } else {
                XCTFail("Expected ContractValidationError")
            }
        }
    }
    
    func testValidateApiContract() throws {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        
        let validContract = ApiContract(
            id: "valid-id",
            version: version,
            name: "Valid API Contract",
            metadata: metadata,
            method: .GET,
            path: "/api/users"
        )
        
        XCTAssertNoThrow(try ContractsKit.validateApiContract(validContract))
    }
    
    func testValidateApiContractWithInvalidPath() throws {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        
        let invalidContract = ApiContract(
            id: "valid-id",
            version: version,
            name: "Invalid API Contract",
            metadata: metadata,
            method: .GET,
            path: "api/users"
        )
        
        XCTAssertThrowsError(try ContractsKit.validateApiContract(invalidContract)) { error in
            if let validationError = error as? ContractValidationError {
                XCTAssertEqual(validationError.path, "path")
                XCTAssertTrue(validationError.message.contains("must start with"))
            } else {
                XCTFail("Expected ContractValidationError")
            }
        }
    }
    
    func testValidateDataModelContract() throws {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        
        let fields: [String: FieldDefinition] = [
            "id": FieldDefinition(type: "string", required: true)
        ]
        
        let validContract = DataModelContract(
            id: "valid-id",
            version: version,
            name: "Valid Data Model Contract",
            metadata: metadata,
            modelName: "UserModel",
            fields: fields
        )
        
        XCTAssertNoThrow(try ContractsKit.validateDataModelContract(validContract))
    }
    
    func testValidateDataModelContractWithInvalidModelName() throws {
        let metadata = ContractMetadata(author: "Test Author")
        let version = ContractVersion(major: 1, minor: 0, patch: 0)
        
        let fields: [String: FieldDefinition] = [
            "id": FieldDefinition(type: "string", required: true)
        ]
        
        let invalidContract = DataModelContract(
            id: "valid-id",
            version: version,
            name: "Invalid Data Model Contract",
            metadata: metadata,
            modelName: "invalidModelName",
            fields: fields
        )
        
        XCTAssertThrowsError(try ContractsKit.validateDataModelContract(invalidContract)) { error in
            if let validationError = error as? ContractValidationError {
                XCTAssertEqual(validationError.path, "modelName")
                XCTAssertTrue(validationError.message.contains("PascalCase"))
            } else {
                XCTFail("Expected ContractValidationError")
            }
        }
    }
    
    // MARK: - Factory Method Tests
    
    func testCreateEventContract() {
        let payloadSchema = ["userId": "string", "timestamp": "number"]
        let metadata = ContractMetadata(author: "Test Author", tags: ["test"])
        
        let contract = ContractsKit.createEventContract(
            id: "test-event",
            name: "Test Event",
            eventType: "user.created",
            payloadSchema: payloadSchema,
            metadata: metadata
        )
        
        XCTAssertEqual(contract.id, "test-event")
        XCTAssertEqual(contract.name, "Test Event")
        XCTAssertEqual(contract.eventType, "user.created")
        XCTAssertEqual(contract.payload["userId"] as? String, "string")
        XCTAssertEqual(contract.metadata.author, "Test Author")
        XCTAssertEqual(contract.metadata.tags, ["test"])
    }
    
    func testCreateApiContract() {
        let metadata = ContractMetadata(author: "Test Author")
        
        let contract = ContractsKit.createApiContract(
            id: "test-api",
            name: "Test API",
            method: .POST,
            path: "/api/users",
            metadata: metadata
        )
        
        XCTAssertEqual(contract.id, "test-api")
        XCTAssertEqual(contract.name, "Test API")
        XCTAssertEqual(contract.method, .POST)
        XCTAssertEqual(contract.path, "/api/users")
        XCTAssertEqual(contract.metadata.author, "Test Author")
    }
    
    func testCreateDataModelContract() {
        let fields: [String: FieldDefinition] = [
            "id": FieldDefinition(type: "string", required: true),
            "name": FieldDefinition(type: "string", required: true)
        ]
        
        let metadata = ContractMetadata(author: "Test Author")
        
        let contract = ContractsKit.createDataModelContract(
            id: "test-model",
            name: "Test Model",
            modelName: "User",
            fields: fields,
            metadata: metadata
        )
        
        XCTAssertEqual(contract.id, "test-model")
        XCTAssertEqual(contract.name, "Test Model")
        XCTAssertEqual(contract.modelName, "User")
        XCTAssertEqual(contract.fields.count, 2)
        XCTAssertEqual(contract.metadata.author, "Test Author")
    }
}
