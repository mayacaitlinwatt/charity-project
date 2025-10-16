-- ====================================================================
-- Centre404 data validation and error detection queries
-- ====================================================================
-- SQL checks for data integrity and charity business rule compliance
-- ====================================================================

-- ====================================================================
-- foreign key integrity checks
-- ====================================================================

-- checks for orphaned staff training records
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK: No orphaned staff training records'
        ELSE 'ERROR: ' || COUNT(*) || ' staff training records with invalid staff_id'
    END as result
FROM staff_training st
LEFT JOIN staff s ON st.staff_id = s.staff_id
WHERE s.staff_id IS NULL;

-- checks for orphaned assignments
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK: No orphaned assignment records'
        ELSE 'ERROR: ' || COUNT(*) || ' assignment records with invalid references'
    END as result
FROM assignments a
LEFT JOIN users u ON a.user_id = u.user_id
LEFT JOIN services s ON a.service_id = s.service_id
WHERE u.user_id IS NULL OR s.service_id IS NULL;

-- ====================================================================
-- business rules validation
-- ====================================================================

-- checks if users with epilepsy are assigned to untrained staff/volunteers
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK: All epilepsy users have trained providers'
        ELSE 'ERROR: ' || COUNT(*) || ' epilepsy users assigned to untrained providers'
    END as result
FROM users u
JOIN user_conditions uc ON u.user_id = uc.user_id
JOIN conditions c ON uc.condition_id = c.condition_id
JOIN assignments a ON u.user_id = a.user_id
WHERE c.condition_name = 'Epilepsy'
AND NOT EXISTS (
    SELECT 1 FROM staff_training st 
    JOIN training_types tt ON st.training_id = tt.training_id
    WHERE st.staff_id = a.staff_id 
    AND tt.training_name = 'Epilepsy Training'
    AND st.expiry_date > DATE('now')
)
AND NOT EXISTS (
    SELECT 1 FROM volunteer_training vt 
    JOIN training_types tt ON vt.training_id = tt.training_id
    WHERE vt.volunteer_id = a.volunteer_id 
    AND tt.training_name = 'Epilepsy Training'
    AND vt.expiry_date > DATE('now')
);

-- checks for missing required fields
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK: No missing required fields'
        ELSE 'ERROR: ' || COUNT(*) || ' records with missing required data'
    END as result
FROM (
    SELECT user_id FROM users WHERE name IS NULL OR name = ''
    UNION ALL
    SELECT staff_id FROM staff WHERE name IS NULL OR name = ''
    UNION ALL
    SELECT service_id FROM services WHERE service_name IS NULL OR service_name = ''
);

-- checks for scheduling conflicts (i.e. same user, same time)
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN 'OK: No scheduling conflicts'
        ELSE 'ERROR: ' || COUNT(*) || ' scheduling conflicts found'
    END as result
FROM (
    SELECT user_id, assignment_date, assignment_time
    FROM assignments
    GROUP BY user_id, assignment_date, assignment_time
    HAVING COUNT(*) > 1
);
