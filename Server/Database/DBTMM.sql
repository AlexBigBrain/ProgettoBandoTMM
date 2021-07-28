-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema rf7xurjfj41nl2j2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `Words`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Words` ;

CREATE TABLE IF NOT EXISTS `Words` (
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
-- Table `Descriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Descriptions` ;

CREATE TABLE IF NOT EXISTS `Descriptions` (
  `specificWord` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `Description` TEXT CHARACTER SET 'utf8' NOT NULL,
  `LangDesc` SET('IT', 'EN') NOT NULL,
  `descriptionID` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`descriptionID`),
  UNIQUE INDEX `DE_specificWord&description_UNIQUE` (`specificWord` ASC, `Description`(500) ASC) VISIBLE,
  INDEX `DE_specificWord&description_idx` (`specificWord` ASC, `Description`(500) ASC) VISIBLE,
  CONSTRAINT `DE_specificWord_fk`
    FOREIGN KEY (`specificWord`)
    REFERENCES `Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 62
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Examples`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Examples` ;

CREATE TABLE IF NOT EXISTS `Examples` (
  `descriptionID` INT NOT NULL,
  `Example` TEXT CHARACTER SET 'utf8' NOT NULL,
  `LangExample` SET('IT', 'EN') NOT NULL,
  UNIQUE INDEX `EX_descriptionID&Example_UNIQUE` (`descriptionID` ASC, `Example`(500) ASC) VISIBLE,
  INDEX `EX_descriptionID_fk_idx` (`descriptionID` ASC) VISIBLE,
  CONSTRAINT `EX_descriptionID_fk`
    FOREIGN KEY (`descriptionID`)
    REFERENCES `Descriptions` (`descriptionID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Sinonims`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Sinonims` ;

CREATE TABLE IF NOT EXISTS `Sinonims` (
  `SI_wordA_fk` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `SI_wordB_fk` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `SinLang` SET('IT', 'EN') NOT NULL,
  UNIQUE INDEX `SI_wordA&wordB_UNIQUE` (`SI_wordA_fk` ASC, `SI_wordB_fk` ASC) VISIBLE,
  INDEX `SI_wordA_fk_idx` (`SI_wordA_fk` ASC) VISIBLE,
  INDEX `SI_wordB_fk_idx` (`SI_wordB_fk` ASC) VISIBLE,
  CONSTRAINT `SI_wordA_fk`
    FOREIGN KEY (`SI_wordA_fk`)
    REFERENCES `Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `SI_wordB_fk`
    FOREIGN KEY (`SI_wordB_fk`)
    REFERENCES `Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Translations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Translations` ;

CREATE TABLE IF NOT EXISTS `Translations` (
  `TR_wordIT_fk` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  `TR_wordEN_fk` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL,
  UNIQUE INDEX `TR_wordIT&wordEN_UNIQUE` (`TR_wordIT_fk` ASC, `TR_wordEN_fk` ASC) VISIBLE,
  INDEX `TR_wordIT_fk_idx` (`TR_wordIT_fk` ASC) VISIBLE,
  INDEX `TR_wordEN_fk_idx` (`TR_wordEN_fk` ASC) VISIBLE,
  CONSTRAINT `TR_wordEN_fk`
    FOREIGN KEY (`TR_wordEN_fk`)
    REFERENCES `Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `TR_wordIT_fk`
    FOREIGN KEY (`TR_wordIT_fk`)
    REFERENCES `Words` (`specificWord`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- procedure Reorder_DescriptionID
-- -----------------------------------------------------
DROP procedure IF EXISTS `Reorder_DescriptionID`;

DELIMITER $$
CREATE DEFINER=`e6vernyqhz5glc54`@`%` PROCEDURE `Reorder_DescriptionID`()
BEGIN
SET @count = 0;
UPDATE `Descriptions` SET `descriptionID` = @count:= @count + 1;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

DELIMITER $$

DROP TRIGGER IF EXISTS `UpperWordInserted` $$
CREATE
DEFINER=`e6vernyqhz5glc54`@`%`
TRIGGER `rf7xurjfj41nl2j2`.`UpperWordInserted`
BEFORE INSERT ON `rf7xurjfj41nl2j2`.`Words`
FOR EACH ROW
BEGIN
SET new.specificWord = UPPER(TRIM(new.specificWord)),
	new.generalWord = UPPER(TRIM(new.specificWord));
END$$


DROP TRIGGER IF EXISTS `make_specificWord_and_generalWord_equal` $$
CREATE
DEFINER=`e6vernyqhz5glc54`@`%`
TRIGGER `rf7xurjfj41nl2j2`.`make_specificWord_and_generalWord_equal`
BEFORE UPDATE ON `rf7xurjfj41nl2j2`.`Words`
FOR EACH ROW
BEGIN
SET new.specificWord = UPPER(TRIM(new.specificWord)),
	new.generalWord = UPPER(TRIM(new.specificWord));
END$$


DROP TRIGGER IF EXISTS `UPPERspecificWord` $$
CREATE
DEFINER=`e6vernyqhz5glc54`@`%`
TRIGGER `rf7xurjfj41nl2j2`.`UPPERspecificWord`
BEFORE INSERT ON `rf7xurjfj41nl2j2`.`Descriptions`
FOR EACH ROW
BEGIN
	SET new.specificWord = UPPER(new.specificWord),
		new.Description = UPPER(new.Description);
END$$


DROP TRIGGER IF EXISTS `UpdateRequestNumber` $$
CREATE
DEFINER=`e6vernyqhz5glc54`@`%`
TRIGGER `rf7xurjfj41nl2j2`.`UpdateRequestNumber`
AFTER INSERT ON `rf7xurjfj41nl2j2`.`Descriptions`
FOR EACH ROW
BEGIN
	 UPDATE `Words`
     SET `RequestNumber` = 0
     WHERE `specificWord` = new.specificWord;
END$$


DROP TRIGGER IF EXISTS `CheckInsertedSinonims` $$
CREATE
DEFINER=`e6vernyqhz5glc54`@`%`
TRIGGER `rf7xurjfj41nl2j2`.`CheckInsertedSinonims`
BEFORE INSERT ON `rf7xurjfj41nl2j2`.`Sinonims`
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


DROP TRIGGER IF EXISTS `CheckInsertedWord` $$
CREATE
DEFINER=`e6vernyqhz5glc54`@`%`
TRIGGER `rf7xurjfj41nl2j2`.`CheckInsertedWord`
BEFORE INSERT ON `rf7xurjfj41nl2j2`.`Translations`
FOR EACH ROW
BEGIN

IF((SELECT `Words`.`Language` FROM `Words` WHERE `specificWord` = new.TR_wordIT_fk) NOT LIKE '%IT%') THEN
    SET new.TR_wordIT_fk = NULL;
ELSEIF((SELECT `Words`.`Language` FROM `Words` WHERE `specificWord` = new.TR_wordEN_fk) NOT LIKE '%EN%') THEN
	SET new.TR_wordEN_fk = NULL;
END IF;

END$$


DELIMITER ;

INSERT INTO `Words` VALUES ('AFFOLLAMENTO','IT','AFFOLLAMENTO',4),('AGENTE ANTINFETTIVO','IT','AGENTE ANTINFETTIVO',1),('AGENTE PATOGENO','IT','AGENTE PATOGENO',10),('ANTIDOTE','EN','ANTIDOTE',3),('ANTIDOTO','IT','ANTIDOTO',3),('ANTISEPTIC','EN','ANTISEPTIC',1),('ANTISETTICO','IT','ANTISETTICO',1),('ARMADIO',NULL,'ARMADIO',1),('ARRANGEMENT','EN','ARRANGEMENT',1),('ASSEMBRAMENTO','IT','ASSEMBRAMENTO',0),('ATTESTATION','EN','ATTESTATION',1),('ATTESTAZIONE','IT','ATTESTAZIONE',1),('AUTOCERTIFICAZIONE','IT','AUTOCERTIFICAZIONE',0),('AVOIDANCE','EN','AVOIDANCE',1),('CERTIFICATION','EN','CERTIFICATION',1),('CERTIFICAZIONE','IT','CERTIFICAZIONE',1),('CLEANSER','EN','CLEANSER',1),('CONFINEMENT','EN','CONFINEMENT',1),('CONSTRUCTION','EN','CONSTRUCTION',1),('COPRIFUOCO','IT','COPRIFUOCO',0),('COVA','IT','COVA',1),('COVATURA','IT','COVATURA',1),('COVID',NULL,'COVID',2),('CROWD','EN','CROWD',1),('CURFEW','EN','CURFEW',0),('DAD','IT','DAD',0),('DECLARATION','EN','DECLARATION',1),('DECREE-LAW','EN','DECREE-LAW',1),('DESOLATION','EN','DESOLATION',1),('DETERMENT','EN','DETERMENT',1),('DICHIARAZIONE','IT','DICHIARAZIONE',1),('DIDATTICA DIGITALE','IT','DIDATTICA DIGITALE',2),('DIDATTICA ONLINE','IT','DIDATTICA ONLINE',1),('DIFESA','IT','DIFESA',1),('DIOLADRO',NULL,'DIOLADRO',1),('DISINFECTANT','EN','DISINFECTANT',1),('DISINFETTANTE','IT','DISINFETTANTE',0),('DISTACCO','IT','DISTACCO',1),('DISTANCE LEARNING','EN','DISTANCE LEARNING',0),('DPCM','IT,EN','DPCM',0),('DRAGHI',NULL,'DRAGHI',2),('FACE MASK','EN','FACE MASK',0),('FOCOLAIO','IT','FOCOLAIO',0),('FONTE','IT','FONTE',1),('FORESTALLING','EN','FORESTALLING',1),('FORMATION','EN','FORMATION',1),('FORMAZIONE A DISTANZA','IT','FORMAZIONE A DISTANZA',1),('GATHERING','EN','GATHERING',0),('GUANTI',NULL,'GUANTI',1),('HINT','EN','HINT',1),('INCUBATION','EN','INCUBATION',1),('INCUBAZIONE','IT','INCUBAZIONE',1),('INDIZIO','IT','INDIZIO',1),('INTERCEPTION','EN','INTERCEPTION',1),('ISOLAMENTO','IT','ISOLAMENTO',1),('ISOLATION','EN','ISOLATION',1),('LEGISLATIVE DECREE','EN','LEGISLATIVE DECREE',1),('LOCKDOWN','IT,EN','LOCKDOWN',0),('MADONNA TROIA',NULL,'MADONNA TROIA',1),('MALWARE','IT,EN','MALWARE',3),('MASCHERA MEDICA','IT','MASCHERA MEDICA',1),('MASCHERINA','IT','MASCHERINA',0),('MASCHERINA CHIRURGICA','IT','MASCHERINA CHIRURGICA',1),('MASCHERINA IGIENICA','IT','MASCHERINA IGIENICA',1),('MATURAZIONE','IT','MATURAZIONE',1),('MEDICAL MASK','EN','MEDICAL MASK',1),('ORIGIN','EN','ORIGIN',1),('ORIGINE','IT','ORIGINE',1),('OUTBREAK','EN','OUTBREAK',0),('PALLE',NULL,'PALLE',1),('PANDEMIA','IT','PANDEMIA',0),('PANDEMIC','EN','PANDEMIC',0),('PAROLA',NULL,'PAROLA',1),('PATHOGEN','EN','PATHOGEN',2),('PESCA',NULL,'PESCA',3),('PORCDDOI',NULL,'PORCDDOI',2),('PORCODIO',NULL,'PORCODIO',1),('PRECAUZIONE','IT','PRECAUZIONE',1),('PREGIUDIZIO','IT','PREGIUDIZIO',1),('PRELIEVO','IT','PRELIEVO',1),('PREVENTION','EN','PREVENTION',1),('PREVENZIONE','IT','PREVENZIONE',1),('PROCEDURE MASK','EN','PROCEDURE MASK',1),('PROTEZIONE','IT','PROTEZIONE',1),('PROVA',NULL,'PROVA',1),('PÈSCA','IT','PÈSCA',14),('PÉSCA','IT','PÉSCA',14),('QUARANTENA','IT','QUARANTENA',0),('QUARANTINE','EN','QUARANTINE',0),('QUELLI DEL BANDO SONO FIMN',NULL,'QUELLI DEL BANDO SONO FIMN',1),('RAGGRUPPAMENTO','IT','RAGGRUPPAMENTO',1),('RALLY','EN','RALLY',1),('REMOTENESS','EN','REMOTENESS',1),('RESTRICTION','EN','RESTRICTION',1),('ROMITAGGIO','IT','ROMITAGGIO',1),('SANITIZER','EN','SANITIZER',0),('SEGNALE','IT','SEGNALE',1),('SEGREGATION','EN','SEGREGATION',1),('SEGREGAZIONE','IT','SEGREGAZIONE',1),('SELF-CERTIFICATION','EN','SELF-CERTIFICATION',0),('SELFCERTIFICATION',NULL,'SELFCERTIFICATION',1),('SEPARAZIONE','IT','SEPARAZIONE',1),('SIGN','EN','SIGN',1),('SINTOMO','IT','SINTOMO',0),('SOLITUDE','EN','SOLITUDE',1),('SOLITUDINE','IT','SOLITUDINE',1),('SORGENTE','IT','SORGENTE',1),('SOSPETTO','IT','SOSPETTO',1),('SOURCE','EN','SOURCE',1),('SWAB','EN','SWAB',0),('SYMPTOM','EN','SYMPTOM',0),('TAMPONE','IT','TAMPONE',0),('TIME LIMIT','EN','TIME LIMIT',1),('TMMCLIENT',NULL,'TMMCLIENT',1),('VACCINE','EN','VACCINE',0),('VACCINO','IT','VACCINO',0),('VIR',NULL,'VIR',1),('VIRUS','IT,EN','VIRUS',0),('WITHDRAWAL','EN','WITHDRAWAL',2),('WOW',NULL,'WOW',1);
INSERT INTO `Translations` VALUES ('ANTIDOTO','ANTIDOTE'),('ANTIDOTO','MALWARE'),('ANTIDOTO','VACCINE');
INSERT INTO `Sinonims` VALUES ('ASSEMBRAMENTO','AFFOLLAMENTO','IT'),('ASSEMBRAMENTO','RAGGRUPPAMENTO','IT'),('AUTOCERTIFICAZIONE','ATTESTAZIONE','IT'),('AUTOCERTIFICAZIONE','CERTIFICAZIONE','IT'),('AUTOCERTIFICAZIONE','DICHIARAZIONE','IT'),('CURFEW','TIME LIMIT','EN'),('DAD','DIDATTICA DIGITALE','IT'),('DAD','DIDATTICA ONLINE','IT'),('DAD','FORMAZIONE A DISTANZA','IT'),('DISINFETTANTE','AGENTE ANTINFETTIVO','IT'),('DISINFETTANTE','ANTISETTICO','IT'),('DPCM','DECREE-LAW','EN'),('DPCM','LEGISLATIVE DECREE','EN'),('FACE MASK','MEDICAL MASK','EN'),('FACE MASK','PROCEDURE MASK','EN'),('FOCOLAIO','FONTE','IT'),('FOCOLAIO','ORIGINE','IT'),('FOCOLAIO','SORGENTE','IT'),('GATHERING','CROWD','EN'),('GATHERING','RALLY','EN'),('MALWARE','VIRUS','IT,EN'),('MASCHERINA','MASCHERA MEDICA','IT'),('MASCHERINA','MASCHERINA CHIRURGICA','IT'),('MASCHERINA','MASCHERINA IGIENICA','IT'),('OUTBREAK','ORIGIN','EN'),('OUTBREAK','SOURCE','EN'),('QUARANTENA','ISOLAMENTO','IT'),('QUARANTENA','SEGREGAZIONE','IT'),('QUARANTINE','ISOLATION','EN'),('QUARANTINE','SEGREGATION','EN'),('RESTRICTION','CURFEW','EN'),('SANITIZER','ANTISEPTIC','EN'),('SANITIZER','CLEANSER','EN'),('SANITIZER','DISINFECTANT','EN'),('SELF-CERTIFICATION','ATTESTATION','EN'),('SELF-CERTIFICATION','CERTIFICATION','EN'),('SELF-CERTIFICATION','DECLARATION','EN'),('SINTOMO','INDIZIO','IT'),('SINTOMO','SEGNALE','IT'),('SWAB','WITHDRAWAL','EN'),('SYMPTOM','HINT','EN'),('SYMPTOM','SIGN','EN'),('TAMPONE','PRELIEVO','IT'),('VACCINE','ANTIDOTE','EN'),('VACCINO','ANTIDOTO','IT'),('VIRUS','AGENTE PATOGENO','IT');
INSERT INTO `Examples` VALUES (1,'NON HA INDOSSATO LA MASCHERINA ED IL VIRUS LO HA INFETTATO.','IT'),(2,'NAVIGANDO SU INTERNET BISOGNA FARE ATTENZIONE AI VIRUS CHE POSSONO INFETTARE IL TUO COMPUTER.','IT'),(3,'HE DIDN’T WORN THE MASK AND THE VIRUS INFECTED HIM.','EN'),(4,'SURFING ON INTERNET YOU HAVE TO PAY ATTENTION ON THE VIRUSES THAT COULD INFECT YOUR COMPUTER.','EN'),(5,'HA FATTO IL VACCINO ED HA AVUTO ALCUNI SINTOMI.','IT'),(5,'IL VACCINO PER LA TUBERCOLOSI HA SALVATO MOLTE VITE.','IT'),(6,'HE HAS DONE THE VACCINE AND HE HAS HAD SOME SYMPTOMS.','EN'),(6,'THE VACCINE FOR TUBERCULOSIS SAVED A LOT OF LIFES.','EN');
INSERT INTO `Descriptions` VALUES ('VIRUS','IN BIOLOGIA, TERMINE CON CUI SI IDENTIFICA UN GRUPPO DI MICRORGANISMI NON CELLULARI. ESSI NON HANNO UN METABOLISMO PROPRIO E DI CONSEGUENZA SONO PARASSITI.','IT',1),('VIRUS','IN INFORMATICA, INSIEME DI DATI NATI CON LO SCOPO DI DANNEGGIARE UN SISTEMA OPERATIVO.','IT',2),('VIRUS','IN BIOLOGY, TERM THAT WE USE FOR IDENTIFY A GROUP OF NON CELLULAR MICROORGANISMS. THEY HAVE NOT GOT AN OWN METABILISM AND SO THEY ARE PARASITES.','EN',3),('VIRUS','IN COMPUTER TECNOLOGY, A DATA SET BORN FORT DAMAGING AN OPERATIVE SYSTEM.','EN',4),('VACCINO','OPERAZIONE SANITARIA CON CUI SI CONFERISCE L’IMMUNITÀ AD UN DETERMINATO AGENTE PATOGENO TRAMITE L’INOCULAZIONE DI UNA VERSIONE ATTENUATA O DI UNA PARTE DI ESSO.','IT',5),('VACCINE','SANITARY OPERATION WITH WHICH WE GIVE THE IMMUNITY FOR A PATHOGEN WITH THE INOCULATION OF A SOFT VERSION OR A PART OF IT.','EN',6),('TAMPONE','PRELIEVO DI MUCOSE VOLTO A SCOPRIRE INFEZIONI IN CAMPO MEDICO O AD ACQUISIRE DNA IN CAMPO POLIZIESCO.','IT',7),('SWAB','MUCOSAL SAMPLINGS AIM TO DISCOVER INFECTIONS IN THE MEDICAL FIELD OR TO GET DNA IN THE POLICE FIELD.','EN',8),('COPRIFUOCO','IL COPRIFUOCO È UN ORDINE IMPOSTO SOLITAMENTE DALLE AUTORITÀ STATALI E/O MILITARI A TUTTI I CIVILI E A TUTTI COLORO CHE NON HANNO UN DETERMINATO PERMESSO RILASCIATO DALLE AUTORITÀ, CONSISTENTE NELL\'OBBLIGO DI RESTARE NELLE PROPRIE ABITAZIONI DURANTE LE ORE NOTTURNE. ANTICAMENTE, USANZA DI SPEGNERE ALLA SERA I FUOCHI DI CASA PER EVITARE INCENDI NOTTURNI E SEGNALE DATO IN TAL SENSO AI CITTADINI.','IT',9),('CURFEW','A RULE THAT EVERYONE MUST STAY AT HOME BETWEEN SPECIFIC TIMES, USUALLY AT NIGHT, ESPECIALLY DURING A WAR OR A PERIOD OF POLITICAL TROUBLE','EN',10),('MASCHERINA','DISPOSITIVO DI PROTEZIONE INDIVIDUALE DEPUTATO ALLA COPERTURA DI NASO E BOCCA. SERVE A EVITARE LA DISPERSIONE DI AGENTI PATOGENI DA CHI LE INDOSSA. NE ESISTONO VARI TIPI, CON GRADI DI PROTEZIONE DIVERSI: FFP2, FFP3, CHIRURGICA, CON FILTRO ETC.','IT',11),('FACE MASK','PERSONAL PROTECTIVE EQUIPMENT THAT PREVENTS AIRBORNE TRANSMISSION AND INFECTIONS INTO AND FROM THE WEARER’S MOUTH AND NOSE. THERE ARE MANY KINDS OF MASKS: SURGICAL MASKS, FFP2, FFP3 ETC.','EN',12),('DPCM','UN DECRETO MINISTERIALE (D.M.), NELL\'ORDINAM ENTO GIURIDICO ITALIANO, È UN ATTO AMMINISTRATI VO EMANATO DA UN MINISTRO NELL\'ESERCIZI O DELLA SUA FUNZIONE E NELL\'AMBITO DELLE MATERIE DI COMPETENZA DEL SUO DICASTERO. QUANDO È EMANATO DAL PRESIDENTE DEL CONSIGLIO DEI MINISTRI PRENDE LA DENOMINAZI ONE DI DECRETO DEL PRESIDENTE DEL CONSIGLIO DEI MINISTRI (D.P.C.M.).','IT',13),('DPCM','THE PRIME MINISTERIAL DECREES ARE ADMINISTRATIVE ACTS ISSUED BY THE PRIME MINISTER. FORMERLY THESE ARE SECOND GRADE ACTS, AS IN THE JURIDICAL -INSTITUTIONAL HIERARCHY THEY ARE SITUATED ON A LOWER LEVEL THAN LAW. THEIR CONTENT GENERALLY REGARDS TECHNICAL MATTERS, FROM MORE DETAILED ONES TO MORE GENERAL ONES. THE LEGISLATIVE DECREE HAS TO BE PRESCRIBED BY LAW, THAT DETERMINES ITS GENERAL GUIDING PRINCIPLES, AND FOR ITS ENACTEMENT ARE ENGAGED EXPERTS IN THE FIELD, TECHNICIANS AND ACADEMICS.','EN',14),('ASSEMBRAMENTO','RIUNIONE OCCASIONALE DI PERSONE ALL’APERTO PER DIMOSTRAZIONI O ALTRO, ANCHE AFFOLLAMENTO IN GENERE.','IT',15),('GATHERING','A PARTY OR A MEETING WHEN MANY PEOPLE COME TOGETHER AS A GROUP.','EN',16),('DISINFETTANTE','SOSTANZA CAPACE DI DISTRUGGERE MICRORGANISMI AL FINE DI CONTROLLARE IL RISCHIO DI INFEZIONE PER PERSONE O CONTAMINAZION E DI OGGETTI E AMBIENTE.','IT',17),('SANITIZER','A SUBSTANCE CAPABLE OF DESTROYING MICROORGANISMS TO PREVENT THE RISK OF INFECTION IN HUMANS AND THE RISK OF CONTAMINATION OF PLACES AND OBJECTS.','EN',18),('QUARANTENA','PERIODO DI ISOLAMENTO ORIGINARIAMENTE DI 40 GIORNI, DI PERSONE O ANIMALI PER MOTIVI SANITARI COME AD ESEMPIO MALATTIE CONTAGIOSE, SOLITAMENTE PROLUNGATO.','IT',19),('QUARANTINE','A SPECIFIC PERIOD OF TIME, ORIGINALLY OF 40 DAYS, IN WHICH A PERSON OR ANIMAL THAT HAS A DISEASE, OR MAY HAVE ONE, MUST STAY OR BE KEPT AWAY FROM OTHERS IN ORDER TO PREVENT THE SPREAD OF THE DISEASE','EN',20),('AUTOCERTIFICAZIONE','ATTESTAZIONE DI DATI ANAGRAFICI O DI ALTRI REQUISITI, FIRMATA DALL\'INTESTATARIO SOTTO LA PROPRIA RESPONSABILITÀ E SOSTITUTIVA DEL CERTIFICATO RILASCIATO DA UN UFFICIO PUBBLICO. È FORSE UNA DELLE PAROLE PIÙ IN VOGA NELL’ UTILIZZO COMUNE DEGLI ULTIMI MESI, A CAUSA DI TUTTO CIÒ CHE STA','IT',21),('SELF-CERTIFICATION','CERTIFICATION OF PERSONAL DATA OR OTHER REQUIREMENTS, SIGNED BY THE OWNER UNDER HIS OWN RESPONSABILITY AND A REPLACEMENT FOR THE CERTIFICATE RELEASED BY A PUBLIC OFFICE. IT’S MAYBE ONE OF THE MOST USED WORD OF THE LAST MONTHS, THANKS TO EVERYTHING THAT IS HAPPENING WITH THE NEW COVID-19.','EN',22),('SINTOMO','IN MEDICINA, MANIFESTAZIONE DI UNO STATO PATOLOGICO, AVVERTITA SOGGETTIVAMENTE DAL MALATO.','IT',23),('SYMPTOM','ANY FEELING OF ILLNESS OR PHYSICAL OR MENTAL CHANGE THAT IS CAUSED BY A PARTICULAR DISEASE.','EN',24),('FOCOLAIO','CENTRO DI DIFFUSIONE DI UN FENOMENO NEGATIVO. IL FOCOLAIO DIVENTA IN GENERALE IL CENTRO DI IRRADIAMENTO, DI DIFFUSIONE DI QUALCOSA DI NEGATIVO. MA MENTRE IL FOCUS SI FACEVA FUOCO, IL SUO DIMINUTIVO FOCULUS HA DATO ORIGINE, ATTRAVERSO LE FORME IPOTETICHE DEL FOCULARE E DEL FOCULARIUS, A QUELLI CHE SONO EMERSI IN ITALIANO COME SINONIMI: IL FOCOLARE E FOCOLAIO.','IT',25),('OUTBREAK','CENTRE OF DIFFUSION OF A NEGATIVE PHENOMENON. AN OUTBREAK GENERALLY BECOMES THE CENTER OF IRRADIATION, OF SPREADING OF SOMETHING NEGATIVE.','EN',26),('DAD','LA DIDATTICA A DISTANZA È UNA FORMA DI EDUCAZIONE CARATTERIZZATA DALLA SEPARAZIONE FISICA DEGLI INSEGNANTI E DEGLI STUDENTI, CHE SI AVVALE DELL’UTILIZZO DI TECNOLOGIE PER FACILITARE LA COMUNICAZIONE STUDENTE- INSEGNATE E STUDENTE- STUDENTE.','IT',27),('DISTANCE LEARNING','DISTANCE LEARNING IS A FORM OF EDUCATION IN WHICH THE MAIN ELEMENTS INCLUDE PHYSICAL SEPARATION OF TEACHERS AND STUDENTS DURING INSTRUCTION AND THE USE OF VARIOUS TECHNOLOGIES TO FACILITATE STUDENT-TEACHER AND STUDENT- STUDENT COMMUNICATION.','EN',28),('LOCKDOWN','STATO DI ISOLAMENTO O DI ACCESSO LIMITATO ISTITUITO COME MISURA DI SICUREZZA.','IT',29),('LOCKDOWN','A STATE OF ISOLATION OR RESTRICTED ACCESS INSTITUTED AS A SECURITY MEASURE','EN',30),('PANDEMIA','UNA PANDEMIA È LA DIFFUSIONE DI UNA MALATTIA EPIDEMICA IN VASTE AREE GEOGRAFICHE SU SCALA GLOBALE, COINVOLGENDO DI CONSEGUENZA GRAN PARTE DELLA POPOLAZIONE MONDIALE NELLA MALATTIA STESSA O NEL SEMPLICE RISCHIO DI CONTRARLA. TALE SITUAZIONE PRESUPPONE LA MANCANZA DI IMMUNIZZAZIONE DELL\'UOMO VERSO UN PATOGENO ALTAMENTE PERICOLOSO.','IT',31),('PANDEMIC','A PANDEMIC IS AN EPIDEMIC OF AN INFECTIOUS DISEASE THAT HAS SPREAD ACROSS A LARGE REGION, FOR INSTANCE MULTIPLE CONTINENTS OR WORLDWIDE, AFFECTING A SUBSTANTIAL NUMBER OF PEOPLE. THIS SITUATION PRESUPPOSES THE LACK OF IMMUNIZATION OF HUMANS TOWARDS A HIGHLY DANGEROUS PATHOGEN.','EN',32);
