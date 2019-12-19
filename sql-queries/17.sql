DROP PROCEDURE IF EXISTS ShowWordStatisticsMSA;
DELIMITER $$
CREATE PROCEDURE ShowWordStatisticsMSA()
BEGIN
SELECT lName, count(M.sid) AS numMeanings, 
       count(SYNO.l2) AS numSynonyms,
       count(ANTO.l2) AS numAntonyms
  FROM LEMMA AS L, MEANS AS M, 
       (SELECT DISTINCT M1.lid AS l1, M2.lid AS l2
          FROM MEANS AS M1, MEANS AS M2
         WHERE M1.sid = M2.sid
               AND M1.lid <> M2.lid) AS SYNO,
       (SELECT DISTINCT M3.lid AS l1, M4.lid AS l2
          FROM ANTONYM AS A, MEANS AS M3, MEANS AS M4
         WHERE (A.sid1 = M3.sid AND A.sid2 = M4.sid)
               OR (A.sid2 = M3.sid AND A.sid1 = M4.sid)) AS ANTO         
 WHERE L.lid = M.lid AND L.lid = SYNO.l1 AND L.lid = ANTO.l1
 LIMIT 20;
END$$
DELIMITER ;

CALL ShowWordStatisticsMSA(); 