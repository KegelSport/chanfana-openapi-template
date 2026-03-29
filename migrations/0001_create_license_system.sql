-- migrations/0001_create_license_system.sql
PRAGMA foreign_keys = ON;

CREATE TABLE customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX idx_customers_email
ON customers(email);

CREATE TABLE licenses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    license_key_hash TEXT NOT NULL,
    license_key_prefix TEXT,
    status TEXT NOT NULL DEFAULT 'inactive'
        CHECK (status IN ('inactive', 'active', 'suspended', 'cancelled')),
    device_fingerprint TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_validated_at TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_licenses_license_key_hash
ON licenses(license_key_hash);

CREATE INDEX idx_licenses_customer_id
ON licenses(customer_id);

CREATE INDEX idx_licenses_status
ON licenses(status);

CREATE TABLE entitlements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    license_id INTEGER NOT NULL,
    entitlement_key TEXT NOT NULL,
    entitlement_value TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (license_id) REFERENCES licenses(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_entitlements_license_key
ON entitlements(license_id, entitlement_key);

CREATE INDEX idx_entitlements_license_id
ON entitlements(license_id);