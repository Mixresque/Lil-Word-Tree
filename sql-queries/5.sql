DROP PROCEDURE IF EXISTS ShowMoreFrequentDerivation;
DELIMITER $$
CREATE PROCEDURE ShowMoreFrequentDerivation()
BEGIN
SELECT DISTINCT L1.lName AS base, L2.lName AS derivation
  FROM DERIVED AS D, LEMMA AS L1, LEMMA AS L2,
       (SELECT lid, sum(frequency) as f
          FROM FREQUENCY
         GROUP BY lid) AS T1,
       (SELECT lid, sum(frequency) as f
          FROM FREQUENCY
         GROUP BY lid) AS T2
 WHERE D.parentlid = L1.lid AND D.childlid = L2.lid
       AND T1.lid = L1.lid AND T2.lid = L2.lid
       AND T1.f < T2.f
 LIMIT 20;
END$$
DELIMITER ;

CALL ShowMoreFrequentDerivation();