-- MySQL Script generated by MySQL Workbench
-- Fri May  6 17:42:39 2022
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema dindinagora
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `dindinagora` ;

-- -----------------------------------------------------
-- Schema dindinagora
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dindinagora` DEFAULT CHARACTER SET utf8 ;
USE `dindinagora` ;

-- -----------------------------------------------------
-- Table `dindinagora`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`cliente` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`cliente` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(200) NOT NULL,
  `email` VARCHAR(200) NOT NULL,
  `cpf` INT NOT NULL,
  `data_nascimento` DATETIME NOT NULL,
  `data_criacao` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dindinagora`.`cidade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`cidade` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`cidade` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dindinagora`.`endereco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`endereco` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`endereco` (
  `id` INT UNSIGNED NOT NULL,
  `cliente_id` BIGINT NOT NULL,
  `cidade_id` BIGINT NOT NULL,
  `logradouro` VARCHAR(255) NOT NULL,
  `cep` INT NOT NULL,
  `numero` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dindinagora`.`conta_tipo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`conta_tipo` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`conta_tipo` (
  `id` INT NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dindinagora`.`conta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`conta` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`conta` (
  `id` INT UNSIGNED NOT NULL,
  `cliente_id` BIGINT NOT NULL,
  `conta_tipo_id` BIGINT NOT NULL,
  `saldo` DECIMAL NULL DEFAULT 0,
  `numero_conta` BIGINT UNSIGNED NOT NULL,
  `data_abertura_conta` DATETIME NOT NULL,
  PRIMARY KEY (`id`, `cliente_id`),
  UNIQUE INDEX `saldo_UNIQUE` (`saldo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dindinagora`.`depositos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`depositos` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`depositos` (
  `id` BIGINT UNSIGNED NOT NULL,
  `conta_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dindinagora`.`produtos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`produtos` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`produtos` (
  `id` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `descricao` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dindinagora`.`aquisicoes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`aquisicoes` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`aquisicoes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `produtos_id` INT NOT NULL,
  `cliente_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dindinagora`.`transferencias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`transferencias` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`transferencias` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `conta_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dindinagora`.`estado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dindinagora`.`estado` ;

CREATE TABLE IF NOT EXISTS `dindinagora`.`estado` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cidade_id` INT NOT NULL,
  `nome` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;