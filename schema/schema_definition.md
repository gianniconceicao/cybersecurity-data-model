# Schema Definition

This document explains the purpose of each table and its fields in the cybersecurity data model.

The structure follows a **snowflake schema**, with fact tables capturing key events and dimension tables providing business context. Below is a breakdown of each table and its columns.
---

## Dimension Tables

### `dim_client`
Contains information about the client (organizations).
- `id`: Unique identifier
- `name`: Client name
- `industry`: Sector or industry
- `created_at`: When the client was added

### `dim_department`
Represents departments within a client.
- `id`: Department ID
- `name`: Department name (e.g., IT, HR)
- `client_id`: Foreign key to `dim_client`
- `created_at`: When the department was added

### `dim_user`
Describes employees/users in the organization.
- `id`: User ID
- `first_name`, `last_name`: User name
- `email`: Contact email
- `role`: Job title or role
- `department_id`: Foreign key to department
- `client_id`: Foreign key to client
- `created_at`: Timestamp of creation

### `dim_device`
Information about company devices.
- `id`: Device ID
- `hostname`, `ip_address`: Identifiers
- `operating_system`: OS info
- `device_group`: Grouping tag (e.g., endpoint, server)
- `user_id`: Owner or primary user
- `created_at`: Timestamp

### `dim_date`
Standard calendar dimension for temporal queries.
- `id`: Surrogate key
- `date`: Actual calendar date
- `year`, `month`, `day`, `week`, `quarter`, `is_weekend`: Derived fields

---

## Fact Tables

### `fact_vulnerabilities`
Tracks vulnerabilities found on devices.
- `device_id`, `date_id`: Foreign keys
- `type`, `severity`, `status`: Classification fields
- `detection_timestamp`: When it was found

### `fact_attacks`
Records detected attacks linked to vulnerabilities.
- `device_id`, `date_id`: Context
- `vulnerability_fact_id`: Linked vulnerability
- `attack_type`: Threat vector
- `detection_timestamp`: Time of detection
- `prevented`: Whether it was mitigated
- `estimated_cost`: Financial impact estimate

### `fact_mitigations`
Details mitigation actions for each vulnerability or attack.
- `vulnerability_fact_id`: What was fixed
- `attack_id`: If the action targeted an attack
- `mitigation_action`: What was done
- `mitigation_timestamp`: When

### `fact_red_team_breaches`
Captures red team (ethical hacking) breaches.
- `device_id`, `date_id`: Context
- `attack_id`: If linked to an attack
- `breach_type`: Nature of breach
- `is_repeat`: Flag for repeated incidents

### `fact_security_training`
Tracks employee participation in training.
- `user_id`, `date_id`: Context
- `training_type`: Type of content
- `completed`: Boolean flag
- `completion_timestamp`: When training was completed
