DROP PROCEDURE IF EXISTS ShowCommonPercent;
DELIMITER $$
CREATE PROCEDURE ShowCommonPercent() BEGIN
	SELECT numSyllables,SUM(isCommon) AS NumCommon, 
		CONCAT(SUM(isCommon)/COUNT(*)*100,'%') AS CommonPercentage
	FROM LEMMA
	GROUP BY numSyllables
	LIMIT 7;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ShowAvgSyl;
DELIMITER $$
CREATE PROCEDURE ShowAvgSyl() BEGIN
	SELECT isCommon,AVG(NumSyllables)
	FROM LEMMA
	GROUP BY isCommon;
END$$
DELIMITER ;

CALL ShowCommonPercent();
CALL ShowAvgSyl();
