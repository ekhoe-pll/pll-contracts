/**
 * Core type definitions for PLL contracts
 */

/**
 * Base interface that all contracts must implement
 */
export interface BaseContract {
  /** Unique identifier for the contract */
  id: string;
  /** Version of the contract */
  version: ContractVersion;
  /** Human-readable name */
  name: string;
  /** Contract description */
  description?: string;
  /** Metadata about the contract */
  metadata: ContractMetadata;
  /** Timestamp when contract was created */
  createdAt: string;
  /** Timestamp when contract was last updated */
  updatedAt: string;
}

/**
 * Semantic version representation
 */
export interface ContractVersion {
  major: number;
  minor: number;
  patch: number;
  prerelease?: string;
  build?: string;
}

/**
 * Additional metadata for contracts
 */
export interface ContractMetadata {
  /** Author of the contract */
  author?: string;
  /** Tags for categorization */
  tags?: string[];
  /** External documentation URL */
  documentationUrl?: string;
  /** Deprecation information */
  deprecated?: boolean;
  /** Deprecation reason if deprecated */
  deprecationReason?: string;
}

/**
 * Generic event contract structure
 */
export interface EventContract extends BaseContract {
  /** Event type identifier */
  eventType: string;
  /** Event payload schema */
  payload: Record<string, any>;
  /** Event metadata */
  eventMetadata?: EventMetadata;
}

/**
 * Event-specific metadata
 */
export interface EventMetadata {
  /** Event priority */
  priority?: 'low' | 'normal' | 'high' | 'critical';
  /** Event category */
  category?: string;
  /** Whether event should be persisted */
  persistent?: boolean;
  /** TTL in milliseconds */
  ttl?: number;
}

/**
 * API contract structure
 */
export interface ApiContract extends BaseContract {
  /** HTTP method */
  method: 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH';
  /** API endpoint path */
  path: string;
  /** Request schema */
  requestSchema?: Record<string, any>;
  /** Response schema */
  responseSchema?: Record<string, any>;
  /** Authentication requirements */
  auth?: AuthRequirements;
}

/**
 * Authentication requirements
 */
export interface AuthRequirements {
  /** Required authentication type */
  type: 'none' | 'bearer' | 'basic' | 'api-key' | 'oauth2';
  /** Required scopes/permissions */
  scopes?: string[];
  /** Whether auth is optional */
  optional?: boolean;
}

/**
 * Data model contract
 */
export interface DataModelContract extends BaseContract {
  /** Model name */
  modelName: string;
  /** Model fields */
  fields: Record<string, FieldDefinition>;
  /** Model constraints */
  constraints?: ModelConstraints;
}

/**
 * Field definition in a data model
 */
export interface FieldDefinition {
  /** Field type */
  type: string;
  /** Whether field is required */
  required?: boolean;
  /** Default value */
  default?: any;
  /** Field description */
  description?: string;
  /** Validation rules */
  validation?: ValidationRule[];
}

/**
 * Model constraints
 */
export interface ModelConstraints {
  /** Unique fields */
  unique?: string[];
  /** Indexed fields */
  indexes?: string[];
  /** Foreign key relationships */
  foreignKeys?: ForeignKey[];
}

/**
 * Foreign key relationship
 */
export interface ForeignKey {
  /** Local field */
  field: string;
  /** Referenced model */
  references: string;
  /** Referenced field */
  referencedField: string;
  /** Cascade behavior */
  onDelete?: 'cascade' | 'set-null' | 'restrict';
  /** Update behavior */
  onUpdate?: 'cascade' | 'set-null' | 'restrict';
}

/**
 * Validation rule
 */
export interface ValidationRule {
  /** Rule type */
  type: 'min' | 'max' | 'pattern' | 'enum' | 'custom';
  /** Rule value */
  value: any;
  /** Error message */
  message?: string;
}
