DROP PROCEDURE IF EXISTS CommonPos;
DELIMITER $$
CREATE PROCEDURE CommonPos(easyword INT) BEGIN
	IF easyword = 0 OR easyword = 1 THEN
		SELECT pos,COUNT(pos)
		FROM LEMMA L, MEANS M, SYN S
		WHERE L.lid=M.lid AND M.sid=S.sid AND
			L.isCommon=easyword
		GROUP BY pos
		ORDER BY COUNT(pos) DESC
		LIMIT 1;
	ELSE
		SELECT pos,COUNT(pos)
		FROM LEMMA L, MEANS M, SYN S
		WHERE L.lid=M.lid AND M.sid=S.sid
		GROUP BY pos	
		ORDER BY COUNT(pos) DESC
		LIMIT 1;
	END IF;
END$$
DELIMITER ;

CALL CommonPos(1);
CALL CommonPos(0);
CALL CommonPos(2);
