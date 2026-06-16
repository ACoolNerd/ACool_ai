-- ===== TALENT MANAGEMENT SCHEMA =====

-- Talents table
CREATE TABLE IF NOT EXISTS talents (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20),
  role VARCHAR(100),
  bio TEXT,
  agency_id INTEGER REFERENCES agencies(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Managers table
CREATE TABLE IF NOT EXISTS managers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20),
  company VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agencies table
CREATE TABLE IF NOT EXISTS agencies (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  phone VARCHAR(20),
  location VARCHAR(255),
  website VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Producers table
CREATE TABLE IF NOT EXISTS producers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20),
  specialization VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Content table
CREATE TABLE IF NOT EXISTS content (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  type VARCHAR(50),
  talent_id INTEGER REFERENCES talents(id),
  producer_id INTEGER REFERENCES producers(id),
  status VARCHAR(50),
  url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Calendar events
CREATE TABLE IF NOT EXISTS calendar_events (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  talent_id INTEGER REFERENCES talents(id),
  event_type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Masters (contracts, agreements)
CREATE TABLE IF NOT EXISTS masters (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  document_type VARCHAR(50),
  talent_id INTEGER REFERENCES talents(id),
  agency_id INTEGER REFERENCES agencies(id),
  content TEXT,
  signed_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Workforce (team assignments)
CREATE TABLE IF NOT EXISTS workforce (
  id SERIAL PRIMARY KEY,
  talent_id INTEGER REFERENCES talents(id),
  project_name VARCHAR(255),
  role VARCHAR(100),
  start_date TIMESTAMP,
  end_date TIMESTAMP,
  status VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- RACI matrix
CREATE TABLE IF NOT EXISTS raci_matrix (
  id SERIAL PRIMARY KEY,
  task_name VARCHAR(255) NOT NULL,
  responsible_id INTEGER REFERENCES managers(id),
  accountable_id INTEGER REFERENCES managers(id),
  consulted_id INTEGER REFERENCES managers(id),
  informed_id INTEGER REFERENCES managers(id),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_talents_agency ON talents(agency_id);
CREATE INDEX IF NOT EXISTS idx_talents_email ON talents(email);
CREATE INDEX IF NOT EXISTS idx_content_talent ON content(talent_id);
CREATE INDEX IF NOT EXISTS idx_content_producer ON content(producer_id);
CREATE INDEX IF NOT EXISTS idx_events_talent ON calendar_events(talent_id);
CREATE INDEX IF NOT EXISTS idx_workforce_talent ON workforce(talent_id);
