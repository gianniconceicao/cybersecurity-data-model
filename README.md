# Cybersecurity Data Model

This project presents a snowflake-schema data model designed for reporting in a cybersecurity operations platform.

This approach avoids data redundancy and better reflects real-world hierarchies, while still providing speed for analysis.

It enables visibility into client risk exposure, threat mitigation performance, and employee security traininig.

## 📊 Goals

Enable analysis of:

- Critical vulnerabilities by device over time
- Response time from threat detection to mitigation
- Cost savings from prevented attacks
- Training completion rates by department

## 📁 Repository Structure

```
cybersecurity-data-model/
├── README.md
├── schema/
│   └── cybersecurity_data_model.dbml -> Model definition
│   └── schema_definition.md -> Tables and columns descriptions
├── sql/
│   ├── create_tables_postgres.sql -> SQL Create table command
│   └── reporting_queries.sql -> SQL queries for reporting
├── sample_data/
│   ├── fact_attacks.csv -> Sample data for tests
│   └── ...
└── .gitignore
└── LICENSE
```

## 📐 Schema Diagram

You can visualize the schema at: [dbdiagram.io](https://dbdiagram.io) using the `cybersecurity_data_model.dbml` file

---

# Assumptions

### Attack
An attack represents any detected security threat or breach attempt against a client device.
It can originate externally, internally, or from red team simulations.

Tracked in: fact_attacks

Always linked to a specific device and vulnerability

May or may not be successfully prevented (prevented = TRUE/FALSE)

May or may not have a mitigation strategy applied

Has an estimated cost impact (if not mitigated)

### Mitigation
A mitigation is a predefined response strategy to an attack.
It reflects the type of action taken (or planned) to contain or neutralize a threat.

Stored in: dim_mitigation

Examples: patching, firewall reconfiguration, account disablement

Contains metadata: response team, expected duration, strategy type

Linked optionally to attacks via mitigation_id in fact_attacks

Multiple attacks can share the same mitigation strategy

### Training
A training represents a formal awareness or security learning activity completed by a user.

Tracked in: fact_security_training

Examples: phishing simulations, compliance modules, password hygiene

Associated with a user and a training date

Completion is tracked via a boolean flag (completed)

Used to measure readiness and compliance by department or client