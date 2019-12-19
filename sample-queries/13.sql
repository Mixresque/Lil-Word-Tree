DROP PROCEDURE IF EXISTS ShowWordsWithSameHyperHypo;
DELIMITER $$
CREATE PROCEDURE ShowWordsWithSameHyperHypo()
BEGIN
    SELECT S1.sid, S2.sid
      FROM SYN AS S1, SYN AS S2
     WHERE NOT EXISTS (SELECT 1
                         FROM HYPONYM AS HA
                        WHERE HA.parentsid = S1.sid
                              AND NOT EXISTS (SELECT 1
                                                FROM HYPONYM AS HB
                                               WHERE HB.parentsid = S2.sid
                                                     AND HB.childsid=
                                                        HA.childsid))
           AND
           NOT EXISTS (SELECT 1
                         FROM HYPONYM AS HC
                        WHERE HA.childsid = S1.sid
                              AND NOT EXISTS (SELECT 1
                                                FROM HYPONYM AS HB
                                               WHERE HB.parentsid = S2.sid
                                                     AND HB.childsid= 
                                                         HA.childsid));
END$$
DELIMITER ;

CALL ShowWordsWithSameHyperHypo();