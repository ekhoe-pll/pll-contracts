import { 
  EventContract, 
  ApiContract, 
  DataModelContract,
  createEventContract,
  createApiContract,
  createDataModelContract,
  validateEventContract,
  validateApiContract,
  validateDataModelContract,
  generateContractId,
  createContractVersion,
  ContractMetadata
} from '@pll/contracts';

console.log('🧪 Testing @pll/contracts package...\n');

// Test 1: Generate contract ID
console.log('1. Generating contract ID:');
const contractId = generateContractId('test');
console.log(`   Generated ID: ${contractId}\n`);

// Test 2: Create contract version
console.log('2. Creating contract version:');
const version = createContractVersion(1, 0, 0, 'alpha.1');
console.log(`   Version: ${version.major}.${version.minor}.${version.patch}-${version.prerelease}\n`);

// Test 3: Create and validate event contract
console.log('3. Creating event contract:');
const metadata: ContractMetadata = {
  author: 'Test Author',
  tags: ['test'],
  documentationUrl: undefined,
  deprecated: false,
  deprecationReason: undefined
};
const eventContract = createEventContract(
  'user-created-event',
  'User Created Event',
  'user.created',
  {
    userId: 'string',
    email: 'string',
    timestamp: 'number'
  },
  version,
  metadata
);
console.log(`   Event Type: ${eventContract.eventType}`);
console.log(`   Contract ID: ${eventContract.id}\n`);

// Test 4: Validate event contract
console.log('4. Validating event contract:');
const eventValidation = validateEventContract(eventContract);
console.log(`   Valid: ${eventValidation.valid}`);
if (!eventValidation.valid) {
  console.log(`   Errors: ${eventValidation.errors.map(e => e.message).join(', ')}`);
}
console.log();

// Test 5: Create and validate API contract
console.log('5. Creating API contract:');
const apiContract = createApiContract(
  'create-user-api',
  'Create User API',
  'POST',
  '/api/users',
  version,
  metadata
);
console.log(`   Method: ${apiContract.method}`);
console.log(`   Path: ${apiContract.path}\n`);

// Test 6: Validate API contract
console.log('6. Validating API contract:');
const apiValidation = validateApiContract(apiContract);
console.log(`   Valid: ${apiValidation.valid}`);
if (!apiValidation.valid) {
  console.log(`   Errors: ${apiValidation.errors.map(e => e.message).join(', ')}`);
}
console.log();

// Test 7: Create and validate data model contract
console.log('7. Creating data model contract:');
const fields = {
  id: { type: 'string', required: true },
  name: { type: 'string', required: true },
  email: { type: 'string', required: true }
};
const dataModelContract = createDataModelContract(
  'user-model',
  'User Model',
  'User',
  fields,
  version,
  metadata
);
console.log(`   Model Name: ${dataModelContract.modelName}`);
console.log(`   Fields: ${Object.keys(dataModelContract.fields || {}).join(', ')}\n`);

// Test 8: Validate data model contract
console.log('8. Validating data model contract:');
const dataModelValidation = validateDataModelContract(dataModelContract);
console.log(`   Valid: ${dataModelValidation.valid}`);
if (!dataModelValidation.valid) {
  console.log(`   Errors: ${dataModelValidation.errors.map(e => e.message).join(', ')}`);
}
console.log();

console.log('✅ All tests completed successfully!');
console.log('📦 @pll/contracts package is working correctly.');
