-- ====================================================================
-- sample data for Centre404 SQL database
-- ====================================================================

-- locations
INSERT INTO locations (location_id, location_name, address) VALUES
(1, 'Centre404 Main Office', '1404 Camden Rd, London N7 0SJ, UK');

-- services
INSERT INTO services (service_id, service_name, description, capacity, location_id) VALUES
(1, 'Playschemes', 'Holiday and after school enrichment for children', 50, 1),
(2, 'Afterschool Clubs', 'After-school activities for children', 30, 1),
(3, '1:1 Support', 'One-to-one support services', 25, 1),
(4, '2:1 Support', 'Two-to-one support services', 15, 1);

-- training types
INSERT INTO training_types (training_id, training_name, description) VALUES
(1, 'Epilepsy Training', 'Training to support individuals with epilepsy'),
(2, 'Moving and Handling', 'Safe moving and handling techniques');

-- conditions
INSERT INTO conditions (condition_id, condition_name, description) VALUES
(1, 'Epilepsy', 'A neurological condition characterized by recurrent seizures');

-- staff
INSERT INTO staff (staff_id, name, email, job_title, phone_number, hire_date) VALUES
(1, 'John', 'john@centre404.org.uk', 'Support Worker', '+55 1234 5678', '2021-01-01');

-- volunteers
INSERT INTO volunteers (volunteer_id, name, email, phone_number, start_date) VALUES
(1, 'James', 'james@centre404.org.uk', '+44 8765 4321', '2022-02-02');

-- users
INSERT INTO users (user_id, name, email, phone_number, registration_date) VALUES
(1, 'Mary', 'mary@email.com', NULL, '2024-01-10');

-- staff training
INSERT INTO staff_training (staff_id, training_id, completion_date, expiry_date) VALUES
(1, 1, '2024-01-20', '2026-01-20');

-- volunteer training
INSERT INTO volunteer_training (volunteer_id, training_id, completion_date, expiry_date) VALUES
(1, 2, '2024-03-15', '2026-03-15');

-- user conditions
INSERT INTO user_conditions (user_id, condition_id, diagnosis_date) VALUES
(1, 1, '2024-01-10');

-- user services
INSERT INTO user_services (user_id, service_id, start_date) VALUES
(1, 3, '2024-01-15'),
(1, 1, '2024-02-20');

-- assignments
INSERT INTO assignments (assignment_id, user_id, service_id, staff_id, volunteer_id, assignment_date, assignment_time, notes) VALUES
(1, 1, 3, 1, NULL, '2024-01-15', '14:30:00', 'Initial 1:1 support assignment for Mary with epilepsy-trained staff'),
(2, 1, 1, NULL, 1, '2024-02-20', '09:00:00', 'Playschemes assignment for Mary with volunteer James');