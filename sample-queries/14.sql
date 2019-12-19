\DROP PROCEDURE IF EXISTS ShowPoSRatioEasy;
DELIMITER $$
CREATE PROCEDURE ShowPoSRatioEasy()
BEGIN       
    SELECT LL.pos AS pos, count(pos)/SUM.cc AS ratio
      FROM (SELECT L.lid, S.pos
              FROM LEMMA AS L, MEANS AS M, SYN AS S
             WHERE L.isCommon AND M.lid = L.lid 
                   AND M.sid = S.sid) AS LL,
           (SELECT count(*) as cc
              FROM LEMMA AS L, MEANS AS M, SYN AS S
             WHERE L.isCommon AND M.lid = L.lid 
                   AND M.sid = S.sid) AS SUM
     GROUP BY LL.pos;
END$$
DELIMITER ;

CALL ShowPoSRatioEasy();