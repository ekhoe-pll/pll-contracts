# contracts-kit

Shared contracts and schemas for PLL applications. This package provides type definitions and validation schemas that are shared between TypeScript/JavaScript and Swift applications.

## Packages

- **npm**: `@pll/contracts`
- **Swift Package Manager**: `ContractsKit`

## Installation

### npm (TypeScript/JavaScript)

```bash
npm install @pll/contracts
```

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/pll/contracts-kit.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/pll/contracts-kit.git`
3. Select version and add to your target

## Usage

### TypeScript/JavaScript

```typescript
import { 
  EventContract, 
  ApiContract, 
  DataModelContract,
  createEventContract,
  validateEventContract 
} from '@pll/contracts';

// Create an event contract
const eventContract = createEventContract(
  'user-created-event',
  'User Created Event',
  'user.created',
  {
    userId: 'string',
    email: 'string',
    timestamp: 'number'
  }
);

// Validate a contract
const result = validateEventContract(eventContract);
if (!result.valid) {
  console.error('Validation errors:', result.errors);
}
```

### Swift

```swift
import ContractsKit

// Create an event contract
let eventContract = ContractsKit.createEventContract(
    id: "user-created-event",
    name: "User Created Event",
    eventType: "user.created",
    payloadSchema: [
        "userId": "string",
        "email": "string",
        "timestamp": "number"
    ]
)

// Validate a contract
do {
    try ContractsKit.validateEventContract(eventContract)
    print("Contract is valid")
} catch let error as ContractValidationError {
    print("Validation error: \(error.message)")
}
```

## Contract Types

### BaseContract

All contracts inherit from `BaseContract` which includes:

- `id`: Unique identifier
- `version`: Semantic version
- `name`: Human-readable name
- `description`: Optional description
- `metadata`: Additional metadata
- `createdAt`: Creation timestamp
- `updatedAt`: Last update timestamp

### EventContract

For event-driven architecture:

```typescript
interface EventContract extends BaseContract {
  eventType: string;
  payload: Record<string, any>;
  eventMetadata?: {
    priority?: 'low' | 'normal' | 'high' | 'critical';
    category?: string;
    persistent?: boolean;
    ttl?: number;
  };
}
```

### ApiContract

For API definitions:

```typescript
interface ApiContract extends BaseContract {
  method: 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH';
  path: string;
  requestSchema?: Record<string, any>;
  responseSchema?: Record<string, any>;
  auth?: {
    type: 'none' | 'bearer' | 'basic' | 'api-key' | 'oauth2';
    scopes?: string[];
    optional?: boolean;
  };
}
```

### DataModelContract

For data model definitions:

```typescript
interface DataModelContract extends BaseContract {
  modelName: string;
  fields: Record<string, {
    type: string;
    required?: boolean;
    default?: any;
    description?: string;
    validation?: ValidationRule[];
  }>;
  constraints?: {
    unique?: string[];
    indexes?: string[];
    foreignKeys?: ForeignKey[];
  };
}
```

## Validation

The package includes comprehensive validation for all contract types:

```typescript
// TypeScript
import { validateEventContract, validateApiContract } from '@pll/contracts';

const result = validateEventContract(contract);
if (!result.valid) {
  result.errors.forEach(error => {
    console.log(`${error.path}: ${error.message}`);
  });
}
```

```swift
// Swift
do {
    try ContractsKit.validateEventContract(contract)
} catch let error as ContractValidationError {
    print("Error at \(error.path): \(error.message)")
}
```

## Utilities

### Contract Management

```typescript
import { 
  generateContractId,
  createContractVersion,
  compareVersions,
  sortContractsByVersion,
  findLatestContractVersion
} from '@pll/contracts';

// Generate unique contract ID
const id = generateContractId('event');

// Create version
const version = createContractVersion(1, 2, 3, 'alpha.1');

// Compare versions
const comparison = compareVersions(v1, v2); // -1, 0, or 1

// Find latest version
const latest = findLatestContractVersion(contracts, 'my-contract');
```

### Swift Utilities

```swift
// Generate unique contract ID
let id = ContractsKit.generateContractId(prefix: "event")

// Create version
let version = ContractsKit.createContractVersion(major: 1, minor: 2, patch: 3, prerelease: "alpha.1")

// Sort contracts by version
let sorted = ContractsKit.sortContractsByVersion(contracts)

// Find latest version
let latest = ContractsKit.findLatestContractVersion(contracts, contractId: "my-contract")
```

## Development

### Prerequisites

- Node.js 18+
- Swift 5.9+
- Xcode 15+ (for Swift development)

### Setup

```bash
# Clone the repository
git clone https://github.com/pll/contracts-kit.git
cd contracts-kit

# Install dependencies
npm install

# Build TypeScript
npm run build

# Clean build artifacts
npm run clean
```

### Swift Development

```bash
# Build Swift package
swift build

# Run Swift tests
swift test

# Generate Xcode project
swift package generate-xcodeproj
```

## Project Structure

```
contracts-kit/
├── src/                    # TypeScript source
│   ├── types/             # Type definitions
│   ├── schemas/           # JSON schemas
│   ├── validation/        # Validation logic
│   ├── utils/             # Utility functions
│   └── index.ts           # Main export
├── Sources/               # Swift source
│   ├── ContractsKit.swift
│   └── ContractsKit+Utilities.swift
├── Tests/                 # Swift tests
├── contracts/             # Example contracts
├── package.json           # npm package config
├── Package.swift          # Swift package config
└── tsconfig.json          # TypeScript config
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

MIT License - see LICENSE file for details.