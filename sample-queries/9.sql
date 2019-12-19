DROP PROCEDURE IF EXISTS ShowDerivationAndSynonyms;
DELIMITER $$
CREATE PROCEDURE ShowDerivationAndSynonyms()
BEGIN
    SELECT DISTINCT L1.lName AS derivation, L2.lName AS base
    FROM DERIVED AS D, LEMMA AS L1, LEMMA AS L2
    WHERE D.parentlid = L1.lid AND D.childlid = L2.lid
        AND EXISTS (SELECT 1
                        FROM MEANS AS M1, MEANS AS M2
                        WHERE M1.lid = D.parentlid
                            AND M2.lid = D.childlid
                            AND M1.sid = M2.sid);   
END$$
DELIMITER ;

CALL ShowDerivationAndSynonyms();