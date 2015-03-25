CREATE TABLE IF NOT EXISTS `__TABLE_PREFIX__email_templates` (
  `id` int(18) NOT NULL AUTO_INCREMENT,
  `created_on` datetime DEFAULT NULL,
  `email_type` int(5) unsigned NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  `use_queue` tinyint(1) NOT NULL DEFAULT '0',
  `email_from` varchar(255) NOT NULL DEFAULT '',
  `email_to` varchar(255) NOT NULL DEFAULT '',
  `subject` varchar(255) DEFAULT NULL,
  `message` text,
  `message_type` varchar(5) NOT NULL DEFAULT 'html',
  `bcc` text,
  `reply_to` varchar(255) DEFAULT NULL,
  `cc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email_template_type` (`email_type`),
  CONSTRAINT `__TABLE_PREFIX__email_templates_ibfk_1` FOREIGN KEY (`email_type`) REFERENCES `__TABLE_PREFIX__email_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `__TABLE_PREFIX__email_types` (
  `id` int(18) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(100) DEFAULT NULL,
  `data` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_type_Code` (`code`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `__TABLE_PREFIX__email_queues` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `state` enum('pending','sent','failed') NOT NULL DEFAULT 'pending',
  `sender_name` varchar(128) DEFAULT NULL,
  `sender_email` varchar(320) NOT NULL,
  `recipient_name` varchar(128) DEFAULT NULL,
  `recipient_email` varchar(320) NOT NULL,
  `subject` varchar(78) DEFAULT NULL,
  `priority` smallint(5) unsigned NOT NULL DEFAULT '1' COMMENT 'Higher priority is a larger number. Priority 5 is higher than priority 1.',
  `attempts` smallint(5) unsigned NOT NULL DEFAULT '0',
  `created_on` datetime NOT NULL,
  `updated_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `state` (`state`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

CREATE TABLE IF NOT EXISTS `__TABLE_PREFIX__email_queue_bodies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queue_id` int(10) unsigned NOT NULL,
  `body` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `queue_id` (`queue_id`),
  CONSTRAINT `__TABLE_PREFIX__email_queue_bodies_ibfk_1` FOREIGN KEY (`queue_id`) REFERENCES `__TABLE_PREFIX__email_queues` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;