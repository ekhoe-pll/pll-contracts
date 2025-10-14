/**
 * JSON Schema definitions for contract validation
 */

import { BaseContract, EventContract, ApiContract, DataModelContract } from '../types';

/**
 * JSON Schema for BaseContract validation
 */
export const baseContractSchema = {
  $schema: 'http://json-schema.org/draft-07/schema#',
  type: 'object',
  required: ['id', 'version', 'name', 'metadata', 'createdAt', 'updatedAt'],
  properties: {
    id: {
      type: 'string',
      pattern: '^[a-zA-Z0-9_-]+$',
      description: 'Unique identifier for the contract'
    },
    version: {
      $ref: '#/definitions/ContractVersion'
    },
    name: {
      type: 'string',
      minLength: 1,
      maxLength: 100,
      description: 'Human-readable name for the contract'
    },
    description: {
      type: 'string',
      maxLength: 500,
      description: 'Optional description of the contract'
    },
    metadata: {
      $ref: '#/definitions/ContractMetadata'
    },
    createdAt: {
      type: 'string',
      format: 'date-time',
      description: 'ISO 8601 timestamp when contract was created'
    },
    updatedAt: {
      type: 'string',
      format: 'date-time',
      description: 'ISO 8601 timestamp when contract was last updated'
    }
  },
  definitions: {
    ContractVersion: {
      type: 'object',
      required: ['major', 'minor', 'patch'],
      properties: {
        major: {
          type: 'integer',
          minimum: 0,
          description: 'Major version number'
        },
        minor: {
          type: 'integer',
          minimum: 0,
          description: 'Minor version number'
        },
        patch: {
          type: 'integer',
          minimum: 0,
          description: 'Patch version number'
        },
        prerelease: {
          type: 'string',
          description: 'Prerelease identifier'
        },
        build: {
          type: 'string',
          description: 'Build metadata'
        }
      }
    },
    ContractMetadata: {
      type: 'object',
      properties: {
        author: {
          type: 'string',
          description: 'Author of the contract'
        },
        tags: {
          type: 'array',
          items: {
            type: 'string'
          },
          description: 'Tags for categorization'
        },
        documentationUrl: {
          type: 'string',
          format: 'uri',
          description: 'External documentation URL'
        },
        deprecated: {
          type: 'boolean',
          description: 'Whether the contract is deprecated'
        },
        deprecationReason: {
          type: 'string',
          description: 'Reason for deprecation'
        }
      }
    }
  }
};

/**
 * JSON Schema for EventContract validation
 */
export const eventContractSchema = {
  $schema: 'http://json-schema.org/draft-07/schema#',
  allOf: [
    { $ref: '#/definitions/BaseContract' },
    {
      type: 'object',
      required: ['eventType', 'payload'],
      properties: {
        eventType: {
          type: 'string',
          pattern: '^[a-zA-Z0-9._-]+$',
          description: 'Event type identifier'
        },
        payload: {
          type: 'object',
          description: 'Event payload schema'
        },
        eventMetadata: {
          $ref: '#/definitions/EventMetadata'
        }
      }
    }
  ],
  definitions: {
    BaseContract: baseContractSchema,
    EventMetadata: {
      type: 'object',
      properties: {
        priority: {
          type: 'string',
          enum: ['low', 'normal', 'high', 'critical'],
          description: 'Event priority level'
        },
        category: {
          type: 'string',
          description: 'Event category'
        },
        persistent: {
          type: 'boolean',
          description: 'Whether event should be persisted'
        },
        ttl: {
          type: 'integer',
          minimum: 0,
          description: 'Time to live in milliseconds'
        }
      }
    }
  }
};

/**
 * JSON Schema for ApiContract validation
 */
export const apiContractSchema = {
  $schema: 'http://json-schema.org/draft-07/schema#',
  allOf: [
    { $ref: '#/definitions/BaseContract' },
    {
      type: 'object',
      required: ['method', 'path'],
      properties: {
        method: {
          type: 'string',
          enum: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
          description: 'HTTP method'
        },
        path: {
          type: 'string',
          pattern: '^/.*',
          description: 'API endpoint path'
        },
        requestSchema: {
          type: 'object',
          description: 'Request payload schema'
        },
        responseSchema: {
          type: 'object',
          description: 'Response payload schema'
        },
        auth: {
          $ref: '#/definitions/AuthRequirements'
        }
      }
    }
  ],
  definitions: {
    BaseContract: baseContractSchema,
    AuthRequirements: {
      type: 'object',
      required: ['type'],
      properties: {
        type: {
          type: 'string',
          enum: ['none', 'bearer', 'basic', 'api-key', 'oauth2'],
          description: 'Authentication type'
        },
        scopes: {
          type: 'array',
          items: {
            type: 'string'
          },
          description: 'Required scopes or permissions'
        },
        optional: {
          type: 'boolean',
          description: 'Whether authentication is optional'
        }
      }
    }
  }
};

/**
 * JSON Schema for DataModelContract validation
 */
export const dataModelContractSchema = {
  $schema: 'http://json-schema.org/draft-07/schema#',
  allOf: [
    { $ref: '#/definitions/BaseContract' },
    {
      type: 'object',
      required: ['modelName', 'fields'],
      properties: {
        modelName: {
          type: 'string',
          pattern: '^[A-Z][a-zA-Z0-9]*$',
          description: 'Model name (PascalCase)'
        },
        fields: {
          type: 'object',
          additionalProperties: {
            $ref: '#/definitions/FieldDefinition'
          },
          description: 'Model field definitions'
        },
        constraints: {
          $ref: '#/definitions/ModelConstraints'
        }
      }
    }
  ],
  definitions: {
    BaseContract: baseContractSchema,
    FieldDefinition: {
      type: 'object',
      required: ['type'],
      properties: {
        type: {
          type: 'string',
          description: 'Field type'
        },
        required: {
          type: 'boolean',
          description: 'Whether field is required'
        },
        default: {
          description: 'Default value for the field'
        },
        description: {
          type: 'string',
          description: 'Field description'
        },
        validation: {
          type: 'array',
          items: {
            $ref: '#/definitions/ValidationRule'
          },
          description: 'Validation rules for the field'
        }
      }
    },
    ModelConstraints: {
      type: 'object',
      properties: {
        unique: {
          type: 'array',
          items: {
            type: 'string'
          },
          description: 'Fields that must be unique'
        },
        indexes: {
          type: 'array',
          items: {
            type: 'string'
          },
          description: 'Fields to be indexed'
        },
        foreignKeys: {
          type: 'array',
          items: {
            $ref: '#/definitions/ForeignKey'
          },
          description: 'Foreign key relationships'
        }
      }
    },
    ForeignKey: {
      type: 'object',
      required: ['field', 'references', 'referencedField'],
      properties: {
        field: {
          type: 'string',
          description: 'Local field name'
        },
        references: {
          type: 'string',
          description: 'Referenced model name'
        },
        referencedField: {
          type: 'string',
          description: 'Referenced field name'
        },
        onDelete: {
          type: 'string',
          enum: ['cascade', 'set-null', 'restrict'],
          description: 'Behavior on delete'
        },
        onUpdate: {
          type: 'string',
          enum: ['cascade', 'set-null', 'restrict'],
          description: 'Behavior on update'
        }
      }
    },
    ValidationRule: {
      type: 'object',
      required: ['type', 'value'],
      properties: {
        type: {
          type: 'string',
          enum: ['min', 'max', 'pattern', 'enum', 'custom'],
          description: 'Validation rule type'
        },
        value: {
          description: 'Validation rule value'
        },
        message: {
          type: 'string',
          description: 'Custom error message'
        }
      }
    }
  }
};

/**
 * Export all schemas
 */
export const schemas = {
  baseContract: baseContractSchema,
  eventContract: eventContractSchema,
  apiContract: apiContractSchema,
  dataModelContract: dataModelContractSchema
};
