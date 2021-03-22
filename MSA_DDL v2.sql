/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   MSA Snowflake DDL - Group Project
** Desc:   Creating the MSA Snowflake Dimensional model
** Auth:   Davi Aragao, Anmol Madan, Shenglin Ye
** Date:   
************************************************/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema msa_snowflake
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `msa_snowflake` DEFAULT CHARACTER SET latin1 ;
USE `msa_snowflake` ;

-- -----------------------------------------------------
--  Table `msa_snowflake`.`dim_location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `msa_snowflake`.`dim_location` (
  `msa_id` INT(10) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100),
  `state` VARCHAR(10) ,
  `total area` DECIMAL(10,2),
  `land area` DECIMAL(10,2) ,
  `water area` DECIMAL(10,2) ,
  `latitude` DECIMAL(15,6) ,
  `longitude` DECIMAL(15,6) ,
  PRIMARY KEY (`msa_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- Steve is great

-- -----------------------------------------------------
-- Table `msa_snowflake`.`dim_industry`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `msa_snowflake`.`dim_industry` (
  `industry_id` INT(10) NOT NULL AUTO_INCREMENT,
  `industry_name` VARCHAR(100),
  PRIMARY KEY (`industry_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 110
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `msa_snowflake`.`dim_year`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `msa_snowflake`.`dim_year` (
  `date_id` INT(8) NOT NULL,
  `year` INT(8),
  PRIMARY KEY (`date_id`),
  UNIQUE INDEX `year` (`year` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `msa_snowflake`.`fact_msa`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `msa_snowflake`.`fact_msa` (
  `fact_id` INT(10) NOT NULL AUTO_INCREMENT,
  `msa_id` INT(8),
  `date_id` INT(8),
  `population` INT(10),
  `gdp` BIGINT,
  `employment` INT (10),
  `personal_income` BIGINT,
  `regional_price_parity` INT(10),
  `zillow_home_value_index` INT(10),
  `zillow_rent_index` INT(10),
  `zillow_for_sale_inventory` INT(10),
  `zillow_one_br_home_value_index` INT(10),
  `zillow_two_br_home_value_index` INT(10),
  `zillow_three_br_home_value_index` INT(10),
  `zillow_four_br_home_value_index` INT(10),
  `zillow_five_br_home_value_index` INT(10),
  `zillow_condo_home_value_index` INT(10),
  PRIMARY KEY (`fact_id`),
  CONSTRAINT `date_id`
	FOREIGN KEY (`date_id`)
	REFERENCES `msa_snowflake`.`dim_year` (`date_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `msa_id`
	FOREIGN KEY (`msa_id`)
	REFERENCES `msa_snowflake`.`dim_location` (`msa_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
    )
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = latin1;

CREATE  INDEX `date_id_idx` ON `msa_snowflake`.`fact_msa` (`date_id` ASC) VISIBLE;
CREATE INDEX `msa_id_idx` ON `msa_snowflake`.`fact_msa` (`msa_id` ASC) VISIBLE;

CREATE TABLE IF NOT EXISTS `msa_snowflake`.`fact_industry` (
  `fact_id2` INT(10) NOT NULL AUTO_INCREMENT,
  `msa_id2` INT(8),
  `date_id2` INT(8),
  `industry_id` INT(8),
  `gdp_change` DECIMAL(5,2),
  PRIMARY KEY (`fact_id2`),
  CONSTRAINT `industry_id`
	FOREIGN KEY (`industry_id`)
	REFERENCES `msa_snowflake`.`dim_industry` (`industry_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `msa_id2`
	FOREIGN KEY (`msa_id2`)
	REFERENCES `msa_snowflake`.`dim_location` (`msa_id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `date_id2`
    FOREIGN KEY (`date_id2`)
    REFERENCES `msa_snowflake`.`dim_year` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
   /*,CONSTRAINT `fk_fact_industry_fact_msa1`
    FOREIGN KEY (`msa_id2` , `date_id2`)
    REFERENCES `msa_snowflake`.`fact_msa` (`msa_id` , `date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION */
    )
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = latin1;

CREATE  INDEX `date_id2_idx` ON `msa_snowflake`.`fact_industry` (`date_id2` ASC) VISIBLE;
CREATE INDEX `msa_id2_idx` ON `msa_snowflake`.`fact_industry` (`msa_id2` ASC) VISIBLE;
CREATE INDEX `industry_id_idx` ON `msa_snowflake`.`fact_industry` (`industry_id` ASC) VISIBLE;
/*CREATE INDEX `fk_fact_industry_fact_msa1_idx` ON `msa_snowflake`.`fact_industry`(`msa_id2` ASC, `date_id2` ASC) VISIBLE;*/

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;