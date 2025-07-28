<!-- file: .github/instructions/protobuf.instructions.md -->
<!-- version: 2.1.0 -->
<!-- guid: 7d6c5b4a-3c2d-1e0f-9a8b-7c6d5e4f3a2b -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

applyTo: "\*_/_.proto"
description: |
Protocol Buffers (protobuf) style and documentation rules for Copilot/AI agents and VS Code Copilot customization. These rules extend the general instructions in `general-coding.instructions.md` and implement comprehensive protobuf best practices including the 1-1-1 design pattern, Edition 2023 features, and Google's style guide.

---

# Protobuf Coding Instructions

## Core Principles

- Follow the [general coding instructions](general-coding.instructions.md)
- Follow the [Google Protobuf Style Guide](https://protobuf.dev/programming-guides/style/)
- Implement the [1-1-1 Best Practice](https://protobuf.dev/best-practices/1-1-1/) - one top-level entity per file
- Use [Edition 2023](https://protobuf.dev/programming-guides/editions/) for all new files
- Follow [Proto Best Practices](https://protobuf.dev/best-practices/dos-donts/)

## Required File Header

All protobuf files must begin with a standard header as described in the [general coding instructions](general-coding.instructions.md):

```protobuf
// file: path/to/file.proto
// version: 1.0.0
// guid: 123e4567-e89b-12d3-a456-426614174000

edition = "2023";

package your.package.name;

option go_package = "github.com/owner/repo/path/to/package;packagepb";
```

## Edition 2023 Requirements

- **MANDATORY**: All proto files MUST use `edition = "2023";` as the first non-comment line
- Enhanced features with better defaults and future-proofing
- Improved validation and hybrid API support
- Better backwards compatibility with proto2/proto3

## 1-1-1 Design Pattern (MANDATORY)

Each protobuf file contains exactly ONE of:

- One message definition
- One enum definition
- One service definition

### Benefits

- **Modularity**: Easy to find and modify specific types
- **Dependency Management**: Clear import relationships
- **Code Generation**: Cleaner generated code
- **Team Collaboration**: Reduces merge conflicts
- **Build Optimization**: Smaller transitive dependencies

### File Organization Structure

```
pkg/module/proto/
├── types/             # Basic types for import (shared)
│   ├── status.proto   # Common enums
│   ├── error.proto    # Error types
│   └── metadata.proto # Metadata structures
├── messages/          # 1-1-1 message definitions
│   ├── user_info.proto
│   └── config_data.proto
├── enums/             # 1-1-1 enum definitions
│   ├── user_status.proto
│   └── priority_level.proto
├── services/          # 1-1-1 service definitions
│   ├── auth_service.proto
│   └── user_service.proto
├── requests/          # Request message definitions
│   ├── create_user_request.proto
│   └── get_user_request.proto
└── responses/         # Response message definitions
    ├── create_user_response.proto
    └── get_user_response.proto
```

## Naming Conventions

### Files

- Use `lower_snake_case.proto` for filenames
- **Services**: `{service_name}_service.proto`
- **Messages**: `{message_name}.proto` (snake_case)
- **Enums**: `{enum_name}.proto` (snake_case)
- **Types**: `{type_category}.proto` for shared types

### Packages

- Use dot-delimited `lower_snake_case`: `gcommon.v1.auth`
- Format: `{project}.{version}.{module}`
- Example: `gcommon.v1.subtitle`, `myproject.v2.storage`

### Messages

- Use `TitleCase` for message names
- Example: `UserInfo`, `ConfigData`, `CreateUserRequest`

### Fields

- Use `snake_case` for field names
- Use pluralized names for repeated fields
- Example: `user_name = 1`, `user_emails = 2`

### Enums

- Use `TitleCase` for enum type names
- Use `UPPER_SNAKE_CASE` for enum values
- **MANDATORY**: First value must be `{ENUM_NAME}_UNSPECIFIED = 0`

```protobuf
enum UserStatus {
  USER_STATUS_UNSPECIFIED = 0;
  USER_STATUS_ACTIVE = 1;
  USER_STATUS_INACTIVE = 2;
  USER_STATUS_SUSPENDED = 3;
}
```

### Services

- Use `TitleCase` for service and method names
- Example: `AuthService`, `GetUserInfo`, `CreateUser`

## Import Guidelines

### Import Order (MANDATORY)

1. **Standard Google imports first**:

   ```protobuf
   import "google/protobuf/timestamp.proto";
   import "google/protobuf/duration.proto";
   import "google/protobuf/any.proto";
   ```

2. **Types imports second** (from types/ directory):

   ```protobuf
   import "pkg/common/proto/types/error_types.proto";
   import "pkg/auth/proto/types/user_status.proto";
   ```

3. **Other module imports third**:
   ```protobuf
   import "pkg/auth/proto/messages/user_info.proto";
   import "pkg/config/proto/messages/config_data.proto";
   ```

## Message Design Patterns

### Standard Field Number Allocation

```protobuf
message ExampleMessage {
  // Required/primary fields (1-15) - single byte encoding
  string id = 1;
  string name = 2;

  // Secondary fields (16-50)
  string description = 16;
  map<string, string> metadata = 17;

  // Timestamps (51-60)
  google.protobuf.Timestamp created_at = 51;
  google.protobuf.Timestamp updated_at = 52;

  // Status/state fields (61-70)
  Status status = 61;
  Error error = 62;

  // Extension range (if needed)
  extensions 1000 to max;
}
```

### Request/Response Pattern

```protobuf
// Request message
message CreateUserRequest {
  UserInfo user_info = 1;
  CreateOptions options = 2;
  google.protobuf.Timestamp request_time = 51;
}

// Response message
message CreateUserResponse {
  UserInfo user = 1;
  ResponseStatus status = 2;
  Error error = 3;
  google.protobuf.Timestamp response_time = 51;
}
```

### Service Definition Pattern

```protobuf
service UserService {
  // Standard CRUD operations
  rpc CreateUser(CreateUserRequest) returns (CreateUserResponse);
  rpc GetUser(GetUserRequest) returns (GetUserResponse);
  rpc UpdateUser(UpdateUserRequest) returns (UpdateUserResponse);
  rpc DeleteUser(DeleteUserRequest) returns (DeleteUserResponse);

  // List operation with pagination
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
}
```

## Types Package Strategy

### Purpose

The `types/` directory contains fundamental, reusable types imported by other protobuf files.

### Implementation Pattern

1. **Define Basic Types First** in `types/`:

   ```protobuf
   // pkg/auth/proto/types/user_status.proto
   edition = "2023";
   package gcommon.v1.auth;

   enum UserStatus {
     USER_STATUS_UNSPECIFIED = 0;
     USER_STATUS_ACTIVE = 1;
     USER_STATUS_INACTIVE = 2;
   }
   ```

2. **Import Types in Messages**:

   ```protobuf
   // pkg/auth/proto/messages/user_info.proto
   edition = "2023";
   package gcommon.v1.auth;

   import "pkg/auth/proto/types/user_status.proto";

   message UserInfo {
     string user_id = 1;
     UserStatus status = 2;  // Imported type
   }
   ```

3. **Avoid Duplication Rules**:
   - **NEVER** redefine types that exist in `types/`
   - **ALWAYS** import from canonical `types/` location
   - **CHECK** existing types before creating new ones

## Edition 2023 Features

### Enhanced Default Values

```protobuf
// Explicit default values for singular fields
int32 result_per_page = 3 [default = 10];
string status = 4 [default = "pending"];
```

### Improved Field Presence

**CRITICAL: Edition 2023 Field Presence Rules**

In Edition 2023, the `optional` label is **NOT ALLOWED**. Instead, use `option features.field_presence` to control field presence:

```protobuf
// ❌ WRONG - Do NOT use 'optional' label in Edition 2023
optional string confidence_score = 1;
optional string parent_id = 2;

// ✅ CORRECT - Use features.field_presence instead
string confidence_score = 1 [features.field_presence = EXPLICIT];
string parent_id = 2 [features.field_presence = EXPLICIT];

// ✅ CORRECT - Default implicit presence (most common)
string user_id = 3;  // Implicit presence (default behavior)
string name = 4;     // Implicit presence (default behavior)
```

**Field Presence Options:**

- `EXPLICIT` - Field can be unset/null (equivalent to old `optional`)
- `IMPLICIT` - Field always has a value (default behavior)
- `LEGACY_REQUIRED` - Field must be set (proto2 style)

**When to Use EXPLICIT Presence:**

- Optional configuration values
- Nullable database fields
- Fields that may not be available in all contexts
- Fields where "unset" vs "default value" matters

```protobuf
message SubtitleRecord {
  string id = 1;                                           // Always present
  string content = 2;                                      // Always present
  double confidence_score = 3 [features.field_presence = EXPLICIT];  // May be unset
  string parent_id = 4 [features.field_presence = EXPLICIT];         // May be unset
}
```

### Better Validation

```protobuf
// Built-in validation rules
string email = 1 [(validate.rules).string.pattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"];
int32 age = 2 [(validate.rules).int32.gte = 0];
```

## Documentation Requirements

### File-Level Documentation

```protobuf
// file: pkg/auth/proto/messages/user_info.proto
// version: 1.0.0
// guid: 123e4567-e89b-12d3-a456-426614174000

edition = "2023";

// Package auth provides authentication and authorization protobuf definitions.
// This package follows the 1-1-1 pattern with one message per file.
package gcommon.v1.auth;

option go_package = "github.com/jdfalk/gcommon/pkg/auth/proto;authpb";
```

### Message Documentation

```protobuf
// UserInfo represents a user account with authentication details.
// This message contains sensitive PII and should be handled according
// to data protection policies.
message UserInfo {
  // Unique identifier for the user account.
  // Format: UUID v4 (36 characters including hyphens).
  string user_id = 1;

  // Current status of the user account.
  // Determines what actions the user can perform.
  UserStatus status = 2;

  // User's email address used for authentication.
  // Must be a valid email format and unique across the system.
  string email = 3;
}
```

### Enum Documentation

```protobuf
// UserStatus defines the possible states of a user account.
// These states control access permissions and available operations.
enum UserStatus {
  // Default unspecified state. Should not be used in practice.
  USER_STATUS_UNSPECIFIED = 0;

  // User account is active and fully functional.
  // User can perform all authorized operations.
  USER_STATUS_ACTIVE = 1;

  // User account is temporarily inactive.
  // User cannot log in but data is preserved.
  USER_STATUS_INACTIVE = 2;

  // User account is suspended due to policy violation.
  // Requires admin intervention to reactivate.
  USER_STATUS_SUSPENDED = 3;
}
```

### Service Documentation

```protobuf
// AuthService provides user authentication and authorization operations.
// All methods require appropriate permissions and rate limiting applies.
service AuthService {
  // Authenticates a user with email and password.
  // Returns JWT token on successful authentication.
  //
  // Rate limit: 10 requests per minute per IP
  // Requires: Valid email/password combination
  // Returns: JWT token valid for 24 hours
  rpc Login(LoginRequest) returns (LoginResponse);

  // Validates an existing JWT token.
  // Returns user information if token is valid.
  //
  // Rate limit: 100 requests per minute per user
  // Requires: Valid JWT token in Authorization header
  // Returns: User information and token validity
  rpc ValidateToken(ValidateTokenRequest) returns (ValidateTokenResponse);
}
```

## Common Patterns and Best Practices

### Error Handling

```protobuf
// Standard error message structure
message Error {
  // Error code following gRPC status codes
  int32 code = 1;

  // Human-readable error message
  string message = 2;

  // Additional error details
  google.protobuf.Any details = 3;

  // Error occurrence timestamp
  google.protobuf.Timestamp timestamp = 4;
}
```

### Pagination

```protobuf
message ListUsersRequest {
  // Maximum number of users to return (1-100)
  int32 page_size = 1 [default = 50];

  // Token for retrieving next page of results
  string page_token = 2;

  // Optional filter criteria
  string filter = 3;
}

message ListUsersResponse {
  // List of users for current page
  repeated UserInfo users = 1;

  // Token for next page (empty if last page)
  string next_page_token = 2;

  // Total number of users matching filter
  int32 total_count = 3;
}
```

### Versioning Strategy

```protobuf
// Use package versioning for API versions
package gcommon.v1.auth;  // Version 1
package gcommon.v2.auth;  // Version 2 (breaking changes)

// Use field deprecation for non-breaking changes
message UserInfo {
  string user_id = 1;
  string email = 2;
  string old_field = 3 [deprecated = true];  // Mark as deprecated
  string new_field = 4;                      // Add new field
}
```

## Build Integration

### buf.yaml Configuration

```yaml
version: v1
breaking:
  use:
    - FILE
lint:
  use:
    - DEFAULT
    - COMMENTS
    - FILE_LOWER_SNAKE_CASE
```

### buf.gen.yaml Configuration

```yaml
version: v1
plugins:
  - plugin: buf.build/protocolbuffers/go
    out: .
    opt:
      - paths=source_relative
      - module=github.com/jdfalk/gcommon
  - plugin: buf.build/grpc/go
    out: .
    opt:
      - paths=source_relative
      - require_unimplemented_servers=false
```

## Validation Commands

### Local Testing

```bash
# Lint specific file
buf lint path/to/file.proto

# Lint entire module
buf lint --path pkg/module/proto/

# Generate code
buf generate

# Check for breaking changes
buf breaking --against '.git#branch=main'
```

### Integration Testing

```bash
# Test Go code generation
go build ./...

# Test imports
go mod tidy

# Validate no circular dependencies
go mod graph | grep -E ".*->.*->.*"
```

## Migration Guidelines

### From Proto2/Proto3 to Edition 2023

1. Change `syntax = "proto3";` to `edition = "2023";`
2. Update package structure to follow 1-1-1 pattern
3. Move shared types to `types/` directory
4. Add proper file headers and documentation
5. Update import statements
6. Test generated code compatibility

### Breaking Change Checklist

- [ ] Field number changes (NEVER do this)
- [ ] Field type changes (carefully evaluate)
- [ ] Message/enum renames (use deprecation first)
- [ ] Package name changes (create new version)
- [ ] Service method signature changes (add new methods)

## Security Considerations

### Sensitive Data Handling

```protobuf
// Mark sensitive fields for proper handling
message UserCredentials {
  string username = 1;

  // Sensitive: Never log this field
  string password_hash = 2 [(sensitive) = true];

  // PII: Handle according to data protection policies
  string email = 3 [(pii) = true];
}
```

### Access Control

```protobuf
// Document security requirements in service methods
service AdminService {
  // Requires: ADMIN role and valid session
  // Audit: Log all calls with user ID and timestamp
  rpc DeleteUser(DeleteUserRequest) returns (DeleteUserResponse);
}
```

This comprehensive protobuf instruction set ensures consistent, maintainable, and scalable protobuf definitions across all projects while following Google's best practices and modern Edition 2023 features.
