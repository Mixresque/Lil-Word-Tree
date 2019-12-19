DROP PROCEDURE IF EXISTS ShowDerivations;
DELIMITER $$
CREATE PROCEDURE ShowDerivations(_w varchar(80))
BEGIN
    SELECT DISTINCT L1.lName as derived, L2.lName as base
    FROM (SELECT *
          FROM DERIVED
          ORDER BY parentlid, childlid) syns,
         (SELECT @t := (SELECT lid FROM LEMMA WHERE lName = _w)) plid,
         LEMMA L1, LEMMA L2
    WHERE find_in_set(parentlid, @t)
          AND length(@t := CONCAT(@t, ',', childlid))
          AND L1.lid = childlid
          AND L2.lid = parentlid;
END$$
DELIMITER ;

CALL ShowDerivations('person');