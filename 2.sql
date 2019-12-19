DROP PROCEDURE IF EXISTS CommonEngWords;
DELIMITER $$
CREATE PROCEDURE CommonEngWords(num INT) BEGIN
	SET @sql= CONCAT('
	SELECT L.lName,SUM(F.frequency) AS totalFreq
	FROM FREQUENCY F, LEMMA L
	WHERE F.lid=L.lid AND L.isCommon=1
	GROUP BY L.lid
	ORDER BY totalFreq DESC
	LIMIT ',num);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

CALL CommonEngWords(20);





