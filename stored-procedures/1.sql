DROP PROCEDURE IF EXISTS FindTOI;
DELIMITER $$
CREATE PROCEDURE FindTOI(topicname VARCHAR(20)) BEGIN
	DROP TABLE IF EXISTS TOI;
	CREATE TABLE TOI (id INT);
	INSERT INTO TOI
		SELECT topicid
		FROM (SELECT *
		      FROM TOPIC
		      ORDER BY ptopicid, topicid) topics,
		     (SELECT @t := (SELECT topicid
				    FROM TOPIC
				    WHERE tName = topicname)) ptid
		WHERE find_in_set(ptopicid, @t)
		      AND length(@t := CONCAT(@t, ',', topicid));
	INSERT INTO TOI	
		SELECT  topicid
		FROM TOPIC
		WHERE tName = topicname;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS CommonEngWords;
DELIMITER $$
CREATE PROCEDURE CommonEngWords(topicname VARCHAR(20),num INT) BEGIN
	CALL FindTOI(topicname);
	SET @sql= CONCAT('
	SELECT L.lName,SUM(F.frequency) AS totalFreq
	FROM CORPUS C, FREQUENCY F, LEMMA L
	WHERE C.cid=F.cid AND F.lid=L.lid 
		AND C.topicid IN (SELECT id FROM TOI)
	GROUP BY L.lid
	ORDER BY totalFreq DESC
	LIMIT ',num);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	DROP TABLE TOI;
END$$
DELIMITER ;

CALL CommonEngWords('all',20);
CALL CommonEngWords('politics',20);





