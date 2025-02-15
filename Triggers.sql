CREATE TABLE Amaz_Triggers (
Message VARCHAR(1000)       );

ALTER TABLE Amaz_Triggers ADD Date_Created TIMESTAMP NULL;
DESCRIBE Amaz_Triggers;

DELIMITER $$ 
CREATE TRIGGER trigger1 BEFORE INSERT
	ON amazonsalesorders 
	FOR EACH ROW BEGIN
		INSERT INTO amaz_triggers VALUES('Added new order record');
	END$$
    
-- DELIMITER;
DELIMITER $$ 
CREATE TRIGGER triggertest BEFORE INSERT
	ON amazonsalesorders 
	FOR EACH ROW BEGIN
		INSERT INTO amaz_triggers VALUES(NEW.`Order ID`, Date_Created.now);
	END$$
    
INSERT INTO amazonsalesorders (Country, `Order ID`) VALUES ('Kenya', 2000);

SELECT * FROM amaz_triggers;
DROP TRIGGER triggertest;