-- DIMENSION TABLES

CREATE TABLE dim_client (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    industry VARCHAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_department (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    client_id INTEGER NOT NULL REFERENCES dim_client(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_user (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR UNIQUE,
    role VARCHAR,
    department_id INTEGER NOT NULL REFERENCES dim_department(id),
    client_id INTEGER NOT NULL REFERENCES dim_client(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_user_department ON dim_user(department_id);
CREATE INDEX idx_user_client ON dim_user(client_id);

CREATE TABLE dim_device (
    id SERIAL PRIMARY KEY,
    hostname VARCHAR,
    ip_address VARCHAR,
    operating_system VARCHAR,
    device_group VARCHAR,
    user_id INTEGER NOT NULL REFERENCES dim_user(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_device_user ON dim_device(user_id);

CREATE TABLE dim_date (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    week INTEGER,
    quarter INTEGER,
    is_weekend BOOLEAN
);
CREATE INDEX idx_date_date ON dim_date(date);

CREATE TABLE dim_attack_origin (
    id SERIAL PRIMARY KEY,
    origin VARCHAR NOT NULL
);

CREATE TABLE dim_vulnerability (
    id SERIAL PRIMARY KEY,
    type VARCHAR,
    severity VARCHAR,
    status VARCHAR,
    detection_timestamp TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_vuln_severity ON dim_vulnerability(severity);

CREATE TABLE dim_mitigation (
    id SERIAL PRIMARY KEY,
    mitigation_action TEXT,
    response_team VARCHAR,
    mitigation_strategy VARCHAR,
    expected_duration_hours INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FACT TABLES

CREATE TABLE fact_attacks (
    id SERIAL PRIMARY KEY,
    device_id INTEGER NOT NULL REFERENCES dim_device(id),
    date_id INTEGER NOT NULL REFERENCES dim_date(id),
    vulnerability_id INTEGER NOT NULL REFERENCES dim_vulnerability(id),
    attack_type VARCHAR,
    attack_origin_id INTEGER NOT NULL REFERENCES dim_attack_origin(id),
    mitigation_id INTEGER REFERENCES dim_mitigation(id),
    detection_timestamp TIMESTAMP,
    prevented BOOLEAN,
    estimated_cost NUMERIC,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_attacks_device ON fact_attacks(device_id);
CREATE INDEX idx_attacks_date ON fact_attacks(date_id);
CREATE INDEX idx_attacks_origin ON fact_attacks(attack_origin_id);
CREATE INDEX idx_attacks_vuln ON fact_attacks(vulnerability_id);
CREATE INDEX idx_attacks_mitigation ON fact_attacks(mitigation_id);

CREATE TABLE fact_security_training (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES dim_user(id),
    date_id INTEGER NOT NULL REFERENCES dim_date(id),
    training_type VARCHAR,
    completed BOOLEAN,
    completion_timestamp TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_training_user ON fact_security_training(user_id);
CREATE INDEX idx_training_date ON fact_security_training(date_id);
CREATE INDEX idx_training_completed ON fact_security_training(completed);
