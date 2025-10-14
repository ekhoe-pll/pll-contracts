# Testing Package Installation

This guide shows you how to test the `contracts-kit` package installation for both TypeScript and Swift projects.

## Local Testing (Development)

### Quick Test
Build both packages to ensure they work:
```bash
npm run build && swift build
```

### Manual Testing

#### TypeScript Package Testing

1. **Build the main package:**
```bash
npm install
npm run build
```

2. **Create a test project:**
```bash
mkdir test-project
cd test-project
npm init -y
npm install ../  # Install the local package
```

3. **Create a test file and run it:**
```typescript
// test.ts
import { createEventContract, validateEventContract } from '@pll/contracts';

const contract = createEventContract(
  'test-event',
  'Test Event', 
  'test.event',
  '{"message": "string"}'
);

const result = validateEventContract(contract);
console.log('Valid:', result.valid);
```

#### Swift Package Testing

1. **Build the main package:**
```bash
swift build
```

2. **Create a test project:**
```bash
mkdir TestProject
cd TestProject
swift package init --type executable
```

3. **Add dependency and test:**
```swift
// Package.swift
dependencies: [
    .package(path: "../")
]
// main.swift
import ContractsKit
// Your test code here
```

## Published Package Testing

Once you publish the package, you can test it in real projects:

### TypeScript/JavaScript

1. **Create a new project:**
```bash
mkdir my-test-project
cd my-test-project
npm init -y
npm install typescript @types/node --save-dev
```

2. **Install the published package:**
```bash
npm install @pll/contracts
```

3. **Create a test file:**
```typescript
// test.ts
import { 
  createEventContract, 
  validateEventContract,
  generateContractId 
} from '@pll/contracts';

console.log('Testing @pll/contracts...');

const id = generateContractId('test');
console.log('Generated ID:', id);

const contract = createEventContract(
  'test-event',
  'Test Event',
  'test.event',
  { message: 'string' }
);

const validation = validateEventContract(contract);
console.log('Contract valid:', validation.valid);
```

4. **Compile and run:**
```bash
npx tsc test.ts
node test.js
```

### Swift Package Manager

1. **Create a new Swift package:**
```bash
mkdir MyTestProject
cd MyTestProject
swift package init --type executable
```

2. **Edit Package.swift:**
```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MyTestProject",
    dependencies: [
        .package(url: "https://github.com/pll/contracts-kit.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "MyTestProject",
            dependencies: ["ContractsKit"]
        )
    ]
)
```

3. **Edit Sources/MyTestProject/main.swift:**
```swift
import ContractsKit

print("Testing ContractsKit...")

let id = ContractsKit.generateContractId(prefix: "test")
print("Generated ID:", id)

let contract = ContractsKit.createEventContract(
    id: "test-event",
    name: "Test Event",
    eventType: "test.event",
    payloadSchema: ["message": "string"]
)

do {
    try ContractsKit.validateEventContract(contract)
    print("Contract is valid!")
} catch {
    print("Validation failed:", error)
}
```

4. **Build and run:**
```bash
swift build
swift run
```

### Xcode Integration

1. **Create a new Xcode project** (iOS, macOS, etc.)

2. **Add package dependency:**
   - File → Add Package Dependencies
   - Enter: `https://github.com/pll/contracts-kit.git`
   - Select version and add to your target

3. **Import and use:**
```swift
import ContractsKit

// Your code here
```

## Publishing the Package

### npm Package

1. **Login to npm:**
```bash
npm login
```

2. **Publish:**
```bash
npm publish --access public
```

### Swift Package

1. **Tag the release:**
```bash
git tag 1.0.0
git push origin 1.0.0
```

2. **The package will be automatically available at:**
```
https://github.com/pll/contracts-kit.git
```

## Verification Checklist

- [ ] TypeScript package installs without errors
- [ ] Swift package resolves dependencies correctly
- [ ] All exports are available and typed correctly
- [ ] Validation functions work as expected
- [ ] Utility functions operate correctly
- [ ] Documentation is accurate
- [ ] Examples run without errors

## Troubleshooting

### Common Issues

1. **TypeScript compilation errors:**
   - Check that all dependencies are installed
   - Verify TypeScript version compatibility
   - Ensure proper module resolution

2. **Swift build errors:**
   - Verify Swift version (5.9+ required)
   - Check Package.swift syntax
   - Ensure all dependencies resolve

3. **Import/export issues:**
   - Verify package.json exports
   - Check TypeScript declaration files
   - Ensure Swift module exports

### Getting Help

- Check the [main README](README.md) for detailed usage examples
- Review the test files in `test-typescript-project/` and `test-swift-project/`
- Ensure your development environment meets the requirements
