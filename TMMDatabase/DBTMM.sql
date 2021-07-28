-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema DBTMM
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DBTMM` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `DBTMM` ;

-- -----------------------------------------------------
-- Table `DBTMM`.`Words`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBTMM`.`Words` ;

CREATE TABLE IF NOT EXISTS `DBTMM`.`Words` (
  `specificWord` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `Language` SET('IT', 'EN') NULL DEFAULT NULL,
  `generalWord` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `RequestNumber` INT NOT NULL DEFAULT '1',
  PRIMARY KEY (`specificWord`),
  INDEX `W_generalWord_idx` (`generalWord` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `DBTMM`.`Descriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBTMM`.`Descriptions` ;

CREATE TABLE IF NOT EXISTS `DBTMM`.`Descriptions` (
  `specificWord` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `Description` TEXT CHARACTER SET 'utf8' NOT NULL,
  `LangDesc` SET('IT', 'EN') NOT NULL,
  `descriptionID` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`descriptionID`),
  UNIQUE INDEX `DE_specificWord&description_UNIQUE` (`specificWord` ASC, `Description`(500) ASC) VISIBLE,
  INDEX `DE_specificWord&description_idx` (`specificWord` ASC, `Description`(500) ASC) VISIBLE,
  CONSTRAINT `DE_specificWord_fk`
    FOREIGN KEY (`specificWord`)
    REFERENCES `DBTMM`.`Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 62
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `DBTMM`.`Examples`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBTMM`.`Examples` ;

CREATE TABLE IF NOT EXISTS `DBTMM`.`Examples` (
  `descriptionID` INT NOT NULL,
  `Example` TEXT CHARACTER SET 'utf8' NOT NULL,
  `LangExample` SET('IT', 'EN') NOT NULL,
  UNIQUE INDEX `EX_descriptionID&Example_UNIQUE` (`descriptionID` ASC, `Example`(500) ASC) VISIBLE,
  INDEX `EX_descriptionID_fk_idx` (`descriptionID` ASC) VISIBLE,
  CONSTRAINT `EX_descriptionID_fk`
    FOREIGN KEY (`descriptionID`)
    REFERENCES `DBTMM`.`Descriptions` (`descriptionID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `DBTMM`.`Sinonims`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBTMM`.`Sinonims` ;

CREATE TABLE IF NOT EXISTS `DBTMM`.`Sinonims` (
  `SI_wordA_fk` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `SI_wordB_fk` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `SinLang` SET('IT', 'EN') NOT NULL,
  UNIQUE INDEX `SI_wordA&wordB_UNIQUE` (`SI_wordA_fk` ASC, `SI_wordB_fk` ASC) VISIBLE,
  INDEX `SI_wordA_fk_idx` (`SI_wordA_fk` ASC) VISIBLE,
  INDEX `SI_wordB_fk_idx` (`SI_wordB_fk` ASC) VISIBLE,
  CONSTRAINT `SI_wordA_fk`
    FOREIGN KEY (`SI_wordA_fk`)
    REFERENCES `DBTMM`.`Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `SI_wordB_fk`
    FOREIGN KEY (`SI_wordB_fk`)
    REFERENCES `DBTMM`.`Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `DBTMM`.`Translations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBTMM`.`Translations` ;

CREATE TABLE IF NOT EXISTS `DBTMM`.`Translations` (
  `TR_wordIT_fk` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `TR_wordEN_fk` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  UNIQUE INDEX `TR_wordIT&wordEN_UNIQUE` (`TR_wordIT_fk` ASC, `TR_wordEN_fk` ASC) VISIBLE,
  INDEX `TR_wordIT_fk_idx` (`TR_wordIT_fk` ASC) VISIBLE,
  INDEX `TR_wordEN_fk_idx` (`TR_wordEN_fk` ASC) VISIBLE,
  CONSTRAINT `TR_wordEN_fk`
    FOREIGN KEY (`TR_wordEN_fk`)
    REFERENCES `DBTMM`.`Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `TR_wordIT_fk`
    FOREIGN KEY (`TR_wordIT_fk`)
    REFERENCES `DBTMM`.`Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `DBTMM` ;

-- -----------------------------------------------------
-- procedure Reorder_DescriptionID
-- -----------------------------------------------------

USE `DBTMM`;
DROP procedure IF EXISTS `DBTMM`.`Reorder_DescriptionID`;

DELIMITER $$
USE `DBTMM`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Reorder_DescriptionID`()
BEGIN
SET @count = 0;
UPDATE `Descriptions` SET `descriptionID` = @count:= @count + 1;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `DBTMM`;

DELIMITER $$

USE `DBTMM`$$
DROP TRIGGER IF EXISTS `DBTMM`.`UpperWordInserted` $$
USE `DBTMM`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `DBTMM`.`UpperWordInserted`
BEFORE INSERT ON `DBTMM`.`Words`
FOR EACH ROW
BEGIN
SET new.specificWord = UPPER(TRIM(new.specificWord)),
	new.generalWord = UPPER(TRIM(new.specificWord));
END$$


USE `DBTMM`$$
DROP TRIGGER IF EXISTS `DBTMM`.`make_specificWord_and_generalWord_equal` $$
USE `DBTMM`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `DBTMM`.`make_specificWord_and_generalWord_equal`
BEFORE UPDATE ON `DBTMM`.`Words`
FOR EACH ROW
BEGIN
SET new.specificWord = UPPER(TRIM(new.specificWord)),
	new.generalWord = UPPER(TRIM(new.specificWord));
END$$


USE `DBTMM`$$
DROP TRIGGER IF EXISTS `DBTMM`.`UPPERspecificWord` $$
USE `DBTMM`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `DBTMM`.`UPPERspecificWord`
BEFORE INSERT ON `DBTMM`.`Descriptions`
FOR EACH ROW
BEGIN
	SET new.specificWord = UPPER(new.specificWord),
		new.Description = UPPER(new.Description);
END$$


USE `DBTMM`$$
DROP TRIGGER IF EXISTS `DBTMM`.`UpdateRequestNumber` $$
USE `DBTMM`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `DBTMM`.`UpdateRequestNumber`
AFTER INSERT ON `DBTMM`.`Descriptions`
FOR EACH ROW
BEGIN
	 UPDATE `Words`
     SET `RequestNumber` = 0
     WHERE `specificWord` = new.specificWord;
END$$


USE `DBTMM`$$
DROP TRIGGER IF EXISTS `DBTMM`.`CheckInsertedSinonims` $$
USE `DBTMM`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `DBTMM`.`CheckInsertedSinonims`
BEFORE INSERT ON `DBTMM`.`Sinonims`
FOR EACH ROW
BEGIN
	SET new.SI_wordA_fk = upper(new.SI_wordA_fk),
		new.SI_wordB_fk = UPPER(new.SI_wordB_fk);
	IF (new.SI_wordA_fk <> new.SI_wordB_fk) THEN

		IF (SELECT ((SELECT `Language` FROM `Words`  WHERE `specificWord` = new.SI_wordA_fk) 
		LIKE (SELECT CONCAT('%',(`Language`),'%')  FROM `Words`  WHERE `specificWord` = new.SI_wordB_fk)) <> 1) THEN

			IF (SELECT ((SELECT `Language` FROM `Words`  WHERE `specificWord` = new.SI_wordB_fk) 
			LIKE (SELECT CONCAT('%',(`Language`),'%')  FROM `Words`  WHERE `specificWord` = new.SI_wordA_fk)) <> 1) THEN

				SET new.SI_wordA_fk = NULL,
					new.SI_wordB_fk = NULL;

            END IF;
		END IF;
	END IF;
    
    IF (SELECT ((SELECT `Language` FROM `Words`  WHERE `specificWord` = new.SI_wordA_fk) 
		LIKE (SELECT CONCAT('%',(`Language`),'%')  FROM `Words`  WHERE `specificWord` = new.SI_wordB_fk)) <> 0) THEN
		
        SET new.SinLang = (SELECT `Language` FROM `Words` WHERE `specificWord` = new.SI_wordB_fk);
        
	ELSEIF (SELECT ((SELECT `Language` FROM `Words`  WHERE `specificWord` = new.SI_wordB_fk) 
			LIKE (SELECT CONCAT('%',(`Language`),'%')  FROM `Words`  WHERE `specificWord` = new.SI_wordA_fk)) <> 0) THEN

		SET new.SinLang = (SELECT `Language` FROM `Words` WHERE `specificWord` = new.SI_wordA_fk);
    
    END IF;
    
END$$


USE `DBTMM`$$
DROP TRIGGER IF EXISTS `DBTMM`.`CheckInsertedWord` $$
USE `DBTMM`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `DBTMM`.`CheckInsertedWord`
BEFORE INSERT ON `DBTMM`.`Translations`
FOR EACH ROW
BEGIN

IF((SELECT `Words`.`Language` FROM `Words` WHERE `specificWord` = new.TR_wordIT_fk) NOT LIKE '%IT%') THEN
    SET new.TR_wordIT_fk = NULL;
ELSEIF((SELECT `Words`.`Language` FROM `Words` WHERE `specificWord` = new.TR_wordEN_fk) NOT LIKE '%EN%') THEN
	SET new.TR_wordEN_fk = NULL;
END IF;

END$$


DELIMITER ;