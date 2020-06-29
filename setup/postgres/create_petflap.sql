-- --------------------------------------------------------
-- Host:                         192.168.0.82
-- Server Version:               PostgreSQL 11.7 (Raspbian 11.7-0+deb10u1) on arm-JSONB-linux-gnueabihf, compiled by gcc (Raspbian 8.3.0-6+rpi1) 8.3.0, 32-bit
-- Server Betriebssystem:        
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES  */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Exportiere Struktur von Tabelle public.motion
DROP TABLE IF EXISTS "motion";
CREATE TABLE IF NOT EXISTS "motion" (
	"event_id" BIGINT NOT NULL,
	"timestamp_local" TIMESTAMP NULL DEFAULT NULL,
	"timestamp_utc" BIGINT NULL DEFAULT NULL,
	"doc" JSONB NULL DEFAULT NULL,
	PRIMARY KEY ("event_id")
);

-- Daten Export vom Benutzer nicht ausgewählt

-- Exportiere Struktur von Tabelle public.motion_log
DROP TABLE IF EXISTS "motion_log";
CREATE TABLE IF NOT EXISTS "motion_log" (
	"event_id" BIGINT NOT NULL,
	"camera" INTEGER NULL DEFAULT NULL,
	"filename" CHAR(80) NOT NULL,
	"frame" INTEGER NULL DEFAULT NULL,
	"file_type" INTEGER NULL DEFAULT NULL,
	"time_stamp" TIMESTAMP NULL DEFAULT NULL,
	"changed_pixels" INTEGER NULL DEFAULT NULL,
	"noise_level" INTEGER NULL DEFAULT NULL,
	"motion_area_h" INTEGER NULL DEFAULT NULL,
	"motion_area_w" INTEGER NULL DEFAULT NULL,
	"motion_center_x" INTEGER NULL DEFAULT NULL,
	"motion_center_y" INTEGER NULL DEFAULT NULL
);

-- Daten Export vom Benutzer nicht ausgewählt

-- Exportiere Struktur von Tabelle public.passage
DROP TABLE IF EXISTS "passage";
CREATE TABLE IF NOT EXISTS "passage" (
	"doc" JSONB NOT NULL,
	"id" INTEGER NOT NULL DEFAULT 'nextval(''passage_id_seq''::regclass)',
	"pet" INTEGER NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "pet" FOREIGN KEY ("pet") REFERENCES "public"."pet" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Daten Export vom Benutzer nicht ausgewählt

-- Exportiere Struktur von Tabelle public.pet
DROP TABLE IF EXISTS "pet";
CREATE TABLE IF NOT EXISTS "pet" (
	"doc" JSONB NOT NULL,
	"id" INTEGER NOT NULL DEFAULT 'nextval(''pet_id_seq''::regclass)',
	PRIMARY KEY ("id")
);

-- Daten Export vom Benutzer nicht ausgewählt

-- Exportiere Struktur von Tabelle public.security
DROP TABLE IF EXISTS "security";
CREATE TABLE IF NOT EXISTS "security" (
	"camera" INTEGER NULL DEFAULT NULL,
	"filename" CHAR(80) NOT NULL,
	"frame" INTEGER NULL DEFAULT NULL,
	"file_type" INTEGER NULL DEFAULT NULL,
	"time_stamp" TIMESTAMP NULL DEFAULT NULL,
	"event_time_stamp" TIMESTAMP NULL DEFAULT NULL
);

-- Daten Export vom Benutzer nicht ausgewählt

-- Exportiere Struktur von Tabelle public.user
DROP TABLE IF EXISTS "user";
CREATE TABLE IF NOT EXISTS "user" (
	"doc" JSONB NOT NULL,
	"id" INTEGER NOT NULL DEFAULT 'nextval(''user_id_seq''::regclass)',
	PRIMARY KEY ("id")
);

-- Daten Export vom Benutzer nicht ausgewählt

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
