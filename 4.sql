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

DROP PROCEDURE IF EXISTS SpecialFreqWords;
DELIMITER $$
CREATE PROCEDURE SpecialFreqWords(topicname VARCHAR(20),num INT) BEGIN
	CALL FindTOI(topicname);
	SET @sql= CONCAT('
	SELECT L.lName,SUM(F.frequency) AS totalFreq
	FROM CORPUS C, FREQUENCY F, LEMMA L
	WHERE C.cid=F.cid AND F.lid=L.lid AND L.isCommon=0
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

DROP PROCEDURE IF EXISTS TFIDF;
DELIMITER $$
CREATE PROCEDURE TFIDF(topicname VARCHAR(20),num INT) BEGIN
	CALL FindTOI(topicname);
	SET @sql= CONCAT('
	SELECT lName,inFreq,numOccur,
	    (inFreq*LN((SELECT COUNT(*) FROM CORPUS)/numOccur)) AS tfidf FROM
		(SELECT L.lName,SUM(F.frequency) AS inFreq
		FROM CORPUS C, FREQUENCY F, LEMMA L
		WHERE C.cid=F.cid AND F.lid=L.lid AND F.frequency>5 
			AND L.isCommon=0 AND C.topicid IN (SELECT id FROM TOI)
		GROUP BY L.lid) AS InDomain
		NATURAL JOIN
		(SELECT L.lName,COUNT(DISTINCT F.cid) AS numOccur
		FROM CORPUS C, FREQUENCY F, LEMMA L
		WHERE C.cid=F.cid AND F.lid=L.lid AND F.frequency>5 
			AND L.isCommon=0
		GROUP BY L.lid) AS AllDomain
	ORDER BY tfidf DESC,inFreq DESC
	LIMIT ',num);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	DROP TABLE TOI;
END$$
DELIMITER ;

CALL SpecialFreqWords('computer',20);
CALL TFIDF('computer',20);
CALL SpecialFreqWords('mythology',20);
CALL TFIDF('mythology',20);





