/**
 * Utility functions for working with contracts
 */

import { BaseContract, ContractVersion, EventContract, ApiContract, DataModelContract } from '../types';

/**
 * Generates a unique contract ID
 */
export function generateContractId(prefix?: string): string {
  const timestamp = Date.now().toString(36);
  const random = Math.random().toString(36).substring(2, 8);
  const id = `${timestamp}-${random}`;
  return prefix ? `${prefix}-${id}` : id;
}

/**
 * Creates a contract version object
 */
export function createContractVersion(
  major: number,
  minor: number,
  patch: number,
  prerelease?: string,
  build?: string
): ContractVersion {
  return {
    major,
    minor,
    patch,
    prerelease,
    build
  };
}

/**
 * Converts a semantic version string to ContractVersion object
 */
export function parseSemanticVersion(version: string): ContractVersion {
  const match = version.match(/^(\d+)\.(\d+)\.(\d+)(?:-([^+]+))?(?:\+(.+))?$/);
  if (!match) {
    throw new Error(`Invalid semantic version: ${version}`);
  }
  
  return {
    major: parseInt(match[1], 10),
    minor: parseInt(match[2], 10),
    patch: parseInt(match[3], 10),
    prerelease: match[4] || undefined,
    build: match[5] || undefined
  };
}

/**
 * Converts a ContractVersion object to semantic version string
 */
export function toSemanticVersion(version: ContractVersion): string {
  let versionString = `${version.major}.${version.minor}.${version.patch}`;
  
  if (version.prerelease) {
    versionString += `-${version.prerelease}`;
  }
  
  if (version.build) {
    versionString += `+${version.build}`;
  }
  
  return versionString;
}

/**
 * Compares two contract versions
 * Returns: -1 if v1 < v2, 0 if v1 === v2, 1 if v1 > v2
 */
export function compareVersions(v1: ContractVersion, v2: ContractVersion): number {
  // Compare major version
  if (v1.major !== v2.major) {
    return v1.major - v2.major;
  }
  
  // Compare minor version
  if (v1.minor !== v2.minor) {
    return v1.minor - v2.minor;
  }
  
  // Compare patch version
  if (v1.patch !== v2.patch) {
    return v1.patch - v2.patch;
  }
  
  // Compare prerelease (undefined is considered higher than any prerelease)
  if (v1.prerelease !== v2.prerelease) {
    if (!v1.prerelease) return 1;
    if (!v2.prerelease) return -1;
    return v1.prerelease.localeCompare(v2.prerelease);
  }
  
  // Versions are equal
  return 0;
}

/**
 * Creates a base contract with default values
 */
export function createBaseContract(
  id: string,
  name: string,
  version: ContractVersion,
  metadata: any = {}
): Partial<BaseContract> {
  const now = new Date().toISOString();
  
  return {
    id,
    name,
    version,
    metadata: {
      ...metadata,
      author: metadata.author || 'Unknown',
      tags: metadata.tags || [],
      deprecated: metadata.deprecated || false
    },
    createdAt: now,
    updatedAt: now
  };
}

/**
 * Updates the updatedAt timestamp of a contract
 */
export function updateContractTimestamp<T extends BaseContract>(contract: T): T {
  return {
    ...contract,
    updatedAt: new Date().toISOString()
  };
}

/**
 * Checks if a contract is deprecated
 */
export function isContractDeprecated(contract: BaseContract): boolean {
  return contract.metadata.deprecated === true;
}

/**
 * Gets contract tags as a comma-separated string
 */
export function getContractTagsString(contract: BaseContract): string {
  return contract.metadata.tags?.join(', ') || '';
}

/**
 * Filters contracts by tag
 */
export function filterContractsByTag<T extends BaseContract>(
  contracts: T[],
  tag: string
): T[] {
  return contracts.filter(contract => 
    contract.metadata.tags?.includes(tag)
  );
}

/**
 * Sorts contracts by version (newest first)
 */
export function sortContractsByVersion<T extends BaseContract>(
  contracts: T[]
): T[] {
  return [...contracts].sort((a, b) => 
    compareVersions(b.version, a.version)
  );
}

/**
 * Finds the latest version of a contract by ID
 */
export function findLatestContractVersion<T extends BaseContract>(
  contracts: T[],
  contractId: string
): T | undefined {
  const matchingContracts = contracts.filter(c => c.id === contractId);
  if (matchingContracts.length === 0) {
    return undefined;
  }
  
  const sorted = sortContractsByVersion(matchingContracts);
  return sorted[0];
}

/**
 * Creates an event contract
 */
export function createEventContract(
  id: string,
  name: string,
  eventType: string,
  payloadSchema: Record<string, any>,
  version: ContractVersion = createContractVersion(1, 0, 0),
  metadata: any = {}
): Partial<EventContract> {
  return {
    ...createBaseContract(id, name, version, metadata),
    eventType,
    payload: payloadSchema
  };
}

/**
 * Creates an API contract
 */
export function createApiContract(
  id: string,
  name: string,
  method: 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH',
  path: string,
  version: ContractVersion = createContractVersion(1, 0, 0),
  metadata: any = {}
): Partial<ApiContract> {
  return {
    ...createBaseContract(id, name, version, metadata),
    method,
    path
  };
}

/**
 * Creates a data model contract
 */
export function createDataModelContract(
  id: string,
  name: string,
  modelName: string,
  fields: Record<string, any>,
  version: ContractVersion = createContractVersion(1, 0, 0),
  metadata: any = {}
): Partial<DataModelContract> {
  return {
    ...createBaseContract(id, name, version, metadata),
    modelName,
    fields
  };
}

/**
 * Deep clones a contract object
 */
export function cloneContract<T extends BaseContract>(contract: T): T {
  return JSON.parse(JSON.stringify(contract));
}

/**
 * Merges two contract metadata objects
 */
export function mergeContractMetadata(
  base: any,
  override: any
): any {
  return {
    ...base,
    ...override,
    tags: [...(base.tags || []), ...(override.tags || [])].filter(
      (tag, index, arr) => arr.indexOf(tag) === index
    )
  };
}
