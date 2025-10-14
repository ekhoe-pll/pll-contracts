/**
 * Contract validation utilities
 */

import { BaseContract, EventContract, ApiContract, DataModelContract } from '../types';
import { schemas } from '../schemas';

/**
 * Validation result interface
 */
export interface ValidationResult {
  /** Whether validation passed */
  valid: boolean;
  /** Array of validation errors */
  errors: ValidationError[];
}

/**
 * Validation error details
 */
export interface ValidationError {
  /** Error path in the object */
  path: string;
  /** Error message */
  message: string;
  /** Invalid value */
  value?: any;
  /** Expected value or constraint */
  expected?: any;
}

/**
 * Validates a base contract against its schema
 */
export function validateBaseContract(contract: any): ValidationResult {
  return validateAgainstSchema(contract, schemas.baseContract);
}

/**
 * Validates an event contract against its schema
 */
export function validateEventContract(contract: any): ValidationResult {
  return validateAgainstSchema(contract, schemas.eventContract);
}

/**
 * Validates an API contract against its schema
 */
export function validateApiContract(contract: any): ValidationResult {
  return validateAgainstSchema(contract, schemas.apiContract);
}

/**
 * Validates a data model contract against its schema
 */
export function validateDataModelContract(contract: any): ValidationResult {
  return validateAgainstSchema(contract, schemas.dataModelContract);
}

/**
 * Generic schema validation function
 * Note: In a real implementation, this would use a JSON Schema validator like ajv
 */
export function validateAgainstSchema(data: any, schema: any): ValidationResult {
  // This is a simplified validation implementation
  // In production, you would use a proper JSON Schema validator like ajv
  
  const errors: ValidationError[] = [];
  
  // Basic type checking for required fields
  if (schema.required) {
    for (const field of schema.required) {
      if (!(field in data) || data[field] === undefined || data[field] === null) {
        errors.push({
          path: field,
          message: `Required field '${field}' is missing`,
          expected: 'defined value'
        });
      }
    }
  }
  
  // Basic property type checking
  if (schema.properties) {
    for (const [property, propSchema] of Object.entries(schema.properties)) {
      if (data[property] !== undefined) {
        const value = data[property];
        const schemaDef = propSchema as any;
        
        // Type validation
        if (schemaDef.type && typeof value !== schemaDef.type) {
          errors.push({
            path: property,
            message: `Field '${property}' must be of type ${schemaDef.type}`,
            value,
            expected: schemaDef.type
          });
        }
        
        // String length validation
        if (schemaDef.type === 'string') {
          if (schemaDef.minLength && value.length < schemaDef.minLength) {
            errors.push({
              path: property,
              message: `Field '${property}' must be at least ${schemaDef.minLength} characters long`,
              value,
              expected: `minimum ${schemaDef.minLength} characters`
            });
          }
          if (schemaDef.maxLength && value.length > schemaDef.maxLength) {
            errors.push({
              path: property,
              message: `Field '${property}' must be at most ${schemaDef.maxLength} characters long`,
              value,
              expected: `maximum ${schemaDef.maxLength} characters`
            });
          }
        }
        
        // Enum validation
        if (schemaDef.enum && !schemaDef.enum.includes(value)) {
          errors.push({
            path: property,
            message: `Field '${property}' must be one of: ${schemaDef.enum.join(', ')}`,
            value,
            expected: schemaDef.enum
          });
        }
      }
    }
  }
  
  return {
    valid: errors.length === 0,
    errors
  };
}

/**
 * Validates a contract ID format
 */
export function validateContractId(id: string): boolean {
  const contractIdPattern = /^[a-zA-Z0-9_-]+$/;
  return contractIdPattern.test(id);
}

/**
 * Validates a semantic version format
 */
export function validateSemanticVersion(version: string): boolean {
  const semverPattern = /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$/;
  return semverPattern.test(version);
}

/**
 * Validates an ISO 8601 date-time string
 */
export function validateISODateTime(dateTime: string): boolean {
  const isoDateTimePattern = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z?$/;
  if (!isoDateTimePattern.test(dateTime)) {
    return false;
  }
  
  try {
    const date = new Date(dateTime);
    return !isNaN(date.getTime()) && date.toISOString() === dateTime;
  } catch {
    return false;
  }
}

/**
 * Creates a validation error
 */
export function createValidationError(
  path: string,
  message: string,
  value?: any,
  expected?: any
): ValidationError {
  return {
    path,
    message,
    value,
    expected
  };
}

/**
 * Combines multiple validation results
 */
export function combineValidationResults(...results: ValidationResult[]): ValidationResult {
  const allErrors = results.flatMap(result => result.errors);
  return {
    valid: allErrors.length === 0,
    errors: allErrors
  };
}
