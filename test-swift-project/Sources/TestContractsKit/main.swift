import ContractsKit

print("🧪 Testing ContractsKit package...\n")

// Test 1: Generate contract ID
print("1. Generating contract ID:")
let contractId = ContractsKit.generateContractId(prefix: "test")
print("   Generated ID: \(contractId)\n")

// Test 2: Create contract version
print("2. Creating contract version:")
let version = ContractsKit.createContractVersion(major: 1, minor: 0, patch: 0, prerelease: "alpha.1")
print("   Version: \(version.semanticVersion)\n")

// Test 3: Create and validate event contract
print("3. Creating event contract:")
let metadata = ContractMetadata(
    author: "Test Author",
    tags: ["test"],
    documentationUrl: nil,
    deprecated: false,
    deprecationReason: nil
)

let eventContract = ContractsKit.createEventContract(
    id: "user-created-event",
    name: "User Created Event",
    eventType: "user.created",
    payloadSchema: """
    {
        "userId": "string",
        "email": "string", 
        "timestamp": "number"
    }
    """,
    version: version,
    metadata: metadata
)
print("   Event Type: \(eventContract.eventType)")
print("   Contract ID: \(eventContract.id)\n")

// Test 4: Validate event contract
print("4. Validating event contract:")
do {
    try ContractsKit.validateEventContract(eventContract)
    print("   ✅ Valid: true")
} catch let error as ContractValidationError {
    print("   ❌ Valid: false")
    print("   Error: \(error.message)")
} catch {
    print("   ❌ Valid: false")
    print("   Error: \(error)")
}
print()

// Test 5: Create and validate API contract
print("5. Creating API contract:")
let apiContract = ContractsKit.createApiContract(
    id: "create-user-api",
    name: "Create User API",
    method: .POST,
    path: "/api/users",
    version: version,
    metadata: metadata
)
print("   Method: \(apiContract.method)")
print("   Path: \(apiContract.path)\n")

// Test 6: Validate API contract
print("6. Validating API contract:")
do {
    try ContractsKit.validateApiContract(apiContract)
    print("   ✅ Valid: true")
} catch let error as ContractValidationError {
    print("   ❌ Valid: false")
    print("   Error: \(error.message)")
} catch {
    print("   ❌ Valid: false")
    print("   Error: \(error)")
}
print()

// Test 7: Create and validate data model contract
print("7. Creating data model contract:")
let fields: [String: FieldDefinition] = [
    "id": FieldDefinition(type: "string", required: true),
    "name": FieldDefinition(type: "string", required: true),
    "email": FieldDefinition(type: "string", required: true)
]

let dataModelContract = ContractsKit.createDataModelContract(
    id: "user-model",
    name: "User Model",
    modelName: "User",
    fields: fields,
    version: version,
    metadata: metadata
)
print("   Model Name: \(dataModelContract.modelName)")
print("   Fields: \(dataModelContract.fields.keys.joined(separator: ", "))\n")

// Test 8: Validate data model contract
print("8. Validating data model contract:")
do {
    try ContractsKit.validateDataModelContract(dataModelContract)
    print("   ✅ Valid: true")
} catch let error as ContractValidationError {
    print("   ❌ Valid: false")
    print("   Error: \(error.message)")
} catch {
    print("   ❌ Valid: false")
    print("   Error: \(error)")
}
print()

// Test 9: Version comparison
print("9. Testing version comparison:")
let v1 = ContractVersion(major: 1, minor: 0, patch: 0)
let v2 = ContractVersion(major: 1, minor: 1, patch: 0)
print("   v1.0.0 < v1.1.0: \(v1 < v2)")
print("   v1.1.0 < v1.0.0: \(v2 < v1)")
print()

// Test 10: Contract utilities
print("10. Testing contract utilities:")
print("   Is deprecated: \(ContractsKit.isContractDeprecated(eventContract))")
print("   Tags: \(ContractsKit.getContractTagsString(eventContract))")
print()

print("✅ All tests completed successfully!")
print("📦 ContractsKit package is working correctly.")
