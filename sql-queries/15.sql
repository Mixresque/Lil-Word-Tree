DROP PROCEDURE IF EXISTS ShowLeaves;
DELIMITER $$
CREATE PROCEDURE ShowLeaves(_t VARCHAR(80))
BEGIN
    SELECT definition
    FROM (SELECT *
          FROM HYPONYM
          ORDER BY parentsid, childsid) hypos,
         (SELECT @t := (SELECT M.sid
                        FROM MEANS M, LEMMA L
                        WHERE M.lid = L.lid AND L.lName = _t
                        LIMIT 1)) psid,
         SYN
    WHERE find_in_set(hypos.parentsid, @t)
          AND length(@t := CONCAT(@t, ',', hypos.childsid))
          AND sid = hypos.childsid
          AND NOT EXISTS (SELECT 1 FROM HYPONYM H WHERE H.parentsid = hypos.childsid);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS CountLeaves;
DELIMITER $$
CREATE PROCEDURE CountLeaves(_t VARCHAR(80))
BEGIN
    SELECT count(hypos.childsid) AS numLeafNodes
    FROM (SELECT *
          FROM HYPONYM
          ORDER BY parentsid, childsid) hypos,
         (SELECT @t := (SELECT M.sid
                        FROM MEANS M, LEMMA L
                        WHERE M.lid = L.lid AND L.lName = _t
                        LIMIT 1)) psid
    WHERE find_in_set(hypos.parentsid, @t)
          AND length(@t := CONCAT(@t, ',', hypos.childsid))
          AND NOT EXISTS (SELECT 1 FROM HYPONYM H WHERE H.parentsid = hypos.childsid);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS Leaves;
DELIMITER $$
CREATE PROCEDURE Leaves(_t VARCHAR(80))
BEGIN
      CALL CountLeaves('food');
      CALL ShowLeaves('food');
END$$
DELIMITER ;

CALL CountLeaves('food');
CALL ShowLeaves('food');