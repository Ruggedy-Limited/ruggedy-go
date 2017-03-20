<?php

use App\Utils\RawMigration;

class AddRuggedyAppRecordAndVulnThumbnailFields extends RawMigration
{
    /**
     * @inheritdoc
     *
     * @return string
     */
    public function getRawSqlMigration()
    {
        return <<<SQL
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

INSERT INTO `scanner_apps` (`name`, `description`, `logo`, `created_at`) VALUES 
('ruggedy', 'Create custom vulnerability entries for your Workspace', '', NOW());

ALTER TABLE `vulnerabilities` 
ADD COLUMN `thumbnail_1` TEXT NULL DEFAULT NULL COMMENT '' AFTER `modified_date_from_scanner`,
ADD COLUMN `thumbnail_2` TEXT NULL DEFAULT NULL COMMENT '' AFTER `thumbnail_1`,
ADD COLUMN `thumbnail_3` TEXT NULL DEFAULT NULL COMMENT '' AFTER `thumbnail_2`,
ADD COLUMN `workspace_app_id` INT(10) UNSIGNED NULL DEFAULT NULL COMMENT '' AFTER `thumbnail_3`,
ADD INDEX `vulnerabilities_workspace_app_fk_idx` (`workspace_app_id` ASC)  COMMENT '';

ALTER TABLE `vulnerabilities` 
ADD CONSTRAINT `vulnerabilities_workspace_app_fk`
  FOREIGN KEY (`workspace_app_id`)
  REFERENCES `workspace_apps` (`id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SQL;

    }
}