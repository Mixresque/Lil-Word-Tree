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

DROP PROCEDURE IF EXISTS ShouldLearn;
DELIMITER $$
CREATE PROCEDURE ShouldLearn(topicname VARCHAR(20),num INT) BEGIN
	CALL FindTOI(topicname);
	SET @sql= CONCAT('
	SELECT lName, 
	    (inFreq/(1+LN((SELECT COUNT(*) FROM CORPUS)/numOccur))) AS tfidf FROM
		(SELECT L.lName,SUM(F.frequency) AS inFreq
		FROM CORPUS C, FREQUENCY F, LEMMA L
		WHERE C.cid=F.cid AND F.lid=L.lid AND F.frequency>5 AND L.isCommon=0 
			AND L.numSyllables>1 AND C.topicid IN (SELECT id FROM TOI)
		GROUP BY L.lid) AS InDomain
		NATURAL JOIN
		(SELECT L.lName,COUNT(DISTINCT F.cid) AS numOccur
		FROM CORPUS C, FREQUENCY F, LEMMA L
		WHERE C.cid=F.cid AND F.lid=L.lid AND F.frequency>5 AND L.isCommon=0 
			AND L.numSyllables>1
		GROUP BY L.lid) AS AllDomain
	ORDER BY tfidf DESC,inFreq DESC
	LIMIT ',num);
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	DROP TABLE TOI;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS GiveDef;
DELIMITER $$
CREATE PROCEDURE GiveDef(topicname VARCHAR(20),num INT) BEGIN
	CALL FindTOI(topicname);
	SET @sql= CONCAT('
	SELECT lName,definition FROM
		(SELECT lid,lName,inFreq,numOccur,
		    (inFreq*LN((SELECT COUNT(*) FROM CORPUS)/numOccur)) AS tfidf FROM
			(SELECT L.lName,L.lid,SUM(F.frequency) AS inFreq
			FROM CORPUS C, FREQUENCY F, LEMMA L
			WHERE C.cid=F.cid AND F.lid=L.lid AND F.frequency>5 
				AND C.topicid IN (SELECT id FROM TOI)
				AND L.lid IN (SELECT lid FROM MEANS)
			GROUP BY L.lid) AS InDomain
			NATURAL JOIN
			(SELECT L.lName,L.lid,COUNT(DISTINCT F.cid) AS numOccur
			FROM CORPUS C, FREQUENCY F, LEMMA L
			WHERE C.cid=F.cid AND F.lid=L.lid AND F.frequency>5 
				AND L.lid IN (SELECT lid FROM MEANS)
			GROUP BY L.lid) AS AllDomain
		ORDER BY tfidf DESC,inFreq DESC
		LIMIT ',num,')AS TopWords NATURAL JOIN MEANS NATURAL JOIN SYN');
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	DROP TABLE TOI;
END$$
DELIMITER ;

CALL ShouldLearn('computer',20);
CALL ShouldLearn('christian',20);
CALL ShouldLearn('space',20);
CALL GiveDef('mythology',20);
