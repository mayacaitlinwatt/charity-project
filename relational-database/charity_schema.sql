-- ====================================================================
-- Charity SQL database schema
-- ====================================================================
-- includes tables for staff, volunteers, users, services, locations, training, 
-- conditions, and assignments. There's also a trigger for users assigned to staff/volunteers without the proper training.
-- ====================================================================

-- staff basic information data table
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    job_title TEXT,
    phone_number TEXT,
    hire_date DATE
);

-- volunteers basic information data table
CREATE TABLE volunteers (
    volunteer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    phone_number TEXT,
    start_date DATE
);

-- users basic information data table
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    phone_number TEXT,
    registration_date DATE
);

-- locations basic information data table
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    location_name TEXT,
    address TEXT
);

-- services basic information data table
CREATE TABLE services (
    service_id INTEGER PRIMARY KEY,
    service_name TEXT NOT NULL,
    description TEXT,
    capacity INTEGER,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- training data table
CREATE TABLE training_types (
    training_id INTEGER PRIMARY KEY,
    training_name TEXT NOT NULL,
    description TEXT
);

-- medical conditions data table
CREATE TABLE conditions (
    condition_id INTEGER PRIMARY KEY,
    condition_name TEXT NOT NULL,
    description TEXT
);

-- junction tables

-- staff and their training
CREATE TABLE staff_training (
    staff_id INTEGER,
    training_id INTEGER,
    completion_date DATE,
    expiry_date DATE,
    PRIMARY KEY (staff_id, training_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (training_id) REFERENCES training_types(training_id)
);

-- volunteers and their training
CREATE TABLE volunteer_training (
    volunteer_id INTEGER,
    training_id INTEGER,
    completion_date DATE,
    expiry_date DATE,
    PRIMARY KEY (volunteer_id, training_id),
    FOREIGN KEY (volunteer_id) REFERENCES volunteers(volunteer_id),
    FOREIGN KEY (training_id) REFERENCES training_types(training_id)
);

-- users and their conditions
CREATE TABLE user_conditions (
    user_id INTEGER,
    condition_id INTEGER,
    diagnosis_date DATE,
    PRIMARY KEY (user_id, condition_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (condition_id) REFERENCES conditions(condition_id)
);

-- users and their services
CREATE TABLE user_services (
    user_id INTEGER,
    service_id INTEGER,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (user_id, service_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- assignments table
CREATE TABLE assignments (
    assignment_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    staff_id INTEGER NULL,
    volunteer_id INTEGER NULL,
    assignment_date DATE NOT NULL,
    assignment_time TIME NOT NULL,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (volunteer_id) REFERENCES volunteers(volunteer_id),
    CHECK ((staff_id IS NOT NULL AND volunteer_id IS NULL) OR 
           (staff_id IS NULL AND volunteer_id IS NOT NULL))
);

-- ====================================================================
-- triggers
-- ====================================================================

CREATE TRIGGER check_epilepsy_training_before_assignment
BEFORE INSERT ON assignments
FOR EACH ROW
BEGIN
  -- checks if user has epilepsy
  SELECT CASE 
    WHEN EXISTS (
      SELECT 1 FROM user_conditions uc 
      JOIN conditions c ON uc.condition_id = c.condition_id
      WHERE uc.user_id = NEW.user_id 
      AND c.condition_name = 'Epilepsy'
    ) THEN
      -- user has epilepsy, checks if provider has training
      CASE 
        WHEN NEW.staff_id IS NOT NULL AND NOT EXISTS (
          SELECT 1 FROM staff_training st
          JOIN training_types tt ON st.training_id = tt.training_id
          WHERE st.staff_id = NEW.staff_id
          AND tt.training_name = 'Epilepsy Training'
          AND st.expiry_date > DATE('now')
        ) THEN RAISE(ABORT, 'staff lacks required epilepsy training')
        
        WHEN NEW.volunteer_id IS NOT NULL AND NOT EXISTS (
          SELECT 1 FROM volunteer_training vt
          JOIN training_types tt ON vt.training_id = tt.training_id
          WHERE vt.volunteer_id = NEW.volunteer_id
          AND tt.training_name = 'Epilepsy Training'
          AND vt.expiry_date > DATE('now')
        ) THEN RAISE(ABORT, 'volunteer lacks required epilepsy training')
      END
  END;
END;
