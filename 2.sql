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
DROP PROCEDURE IF EXISTS FindTOI2;
DELIMITER $$
CREATE PROCEDURE FindTOI2(topicname VARCHAR(20)) BEGIN
	DROP TABLE IF EXISTS TOI2;
	CREATE TABLE TOI2 (id INT);
	INSERT INTO TOI2
		SELECT topicid
		FROM (SELECT *
		      FROM TOPIC
		      ORDER BY ptopicid, topicid) topics,
		     (SELECT @t := (SELECT topicid
				    FROM TOPIC
				    WHERE tName = topicname)) ptid
		WHERE find_in_set(ptopicid, @t)
		      AND length(@t := CONCAT(@t, ',', topicid));
	INSERT INTO TOI2	
		SELECT  topicid
		FROM TOPIC
		WHERE tName = topicname;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS DomainDiff;
DELIMITER $$
CREATE PROCEDURE DomainDiff(topicname VARCHAR(20),
		topic2 VARCHAR(20), num INT) BEGIN
	CALL FindTOI(topicname);
	CALL FindTOI2(topic2);
	SET @sql= CONCAT('
	SELECT lName FROM
	(SELECT L.lName,SUM(F.frequency) AS totalFreq
	FROM CORPUS C, FREQUENCY F, LEMMA L
	WHERE C.cid=F.cid AND F.lid=L.lid AND L.isCommon=0
		AND C.topicid IN (SELECT id FROM TOI)
	GROUP BY L.lid
	ORDER BY totalFreq DESC
	LIMIT ',num*2,') AS list1 WHERE lName NOT IN
		(SELECT lName FROM
		(SELECT L.lName,SUM(F.frequency) AS totalFreq
		FROM CORPUS C, FREQUENCY F, LEMMA L
		WHERE C.cid=F.cid AND F.lid=L.lid AND L.isCommon=0
			AND C.topicid IN (SELECT id FROM TOI2)
		GROUP BY L.lid
		ORDER BY totalFreq DESC LIMIT ',num,')AS list2)
	LIMIT ',num);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	DROP TABLE TOI;
	DROP TABLE TOI2;
END$$
DELIMITER ;

CALL DomainDiff('IBMHard','MacHard',20);
CALL DomainDiff('baseball','hockey',20);
CALL DomainDiff('hockey','baseball',20);





