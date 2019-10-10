﻿--
-- Script was generated by Devart dbForge Studio for MySQL, Version 8.0.40.0
-- Product home page: http://www.devart.com/dbforge/mysql/studio
-- Script date 2019/10/10 18:13:50
-- Server version: 8.0.13
-- Client version: 4.1
--

-- 
-- Disable foreign keys
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Set SQL mode
-- 
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8';

DROP DATABASE IF EXISTS starter;

CREATE DATABASE IF NOT EXISTS starter
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Set default database
--
USE starter;

--
-- Create table `core_user_role`
--
CREATE TABLE IF NOT EXISTS core_user_role (
  ID int(20) NOT NULL AUTO_INCREMENT,
  USER_ID int(20) DEFAULT NULL,
  ROLE_ID int(20) DEFAULT NULL,
  ORG_ID int(20) DEFAULT NULL,
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 173,
AVG_ROW_LENGTH = 712,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = '用户角色关系表';

--
-- Create index `FK_core_user_role_core_role_ID` on table `core_user_role`
--
ALTER TABLE core_user_role
ADD INDEX FK_core_user_role_core_role_ID (ROLE_ID);

--
-- Create table `core_user`
--
CREATE TABLE IF NOT EXISTS core_user (
  ID int(20) NOT NULL AUTO_INCREMENT,
  CODE varchar(16) DEFAULT NULL,
  NAME varchar(16) DEFAULT NULL,
  PASSWORD varchar(64) DEFAULT NULL,
  ORG_ID int(65) DEFAULT NULL,
  STATE varchar(16) DEFAULT NULL COMMENT '用户状态 1:启用 0:停用',
  JOB_TYPE1 varchar(16) DEFAULT NULL,
  DEL_FLAG tinyint(6) DEFAULT NULL COMMENT '用户删除标记 0:未删除 1:已删除',
  JOB_TYPE0 varchar(16) DEFAULT NULL,
  ATTACHMENT_ID varchar(128) DEFAULT NULL,
  INTRODUCTION varchar(256) DEFAULT NULL COMMENT '简介',
  AVATAR varchar(128) DEFAULT NULL COMMENT '头像',
  UPDATE_TIME bigint(11) DEFAULT NULL,
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 176,
AVG_ROW_LENGTH = 2730,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create table `core_role_menu`
--
CREATE TABLE IF NOT EXISTS core_role_menu (
  ID int(20) NOT NULL AUTO_INCREMENT,
  ROLE_ID int(65) DEFAULT NULL,
  MENU_ID int(65) DEFAULT NULL,
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 201,
AVG_ROW_LENGTH = 1820,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `FK_core_role_menu_core_menu_ID` on table `core_role_menu`
--
ALTER TABLE core_role_menu
ADD INDEX FK_core_role_menu_core_menu_ID (MENU_ID);

--
-- Create index `FK_core_role_menu_core_role_ID` on table `core_role_menu`
--
ALTER TABLE core_role_menu
ADD INDEX FK_core_role_menu_core_role_ID (ROLE_ID);

--
-- Create table `core_role_function`
--
CREATE TABLE IF NOT EXISTS core_role_function (
  ID int(20) NOT NULL AUTO_INCREMENT,
  ROLE_ID int(65) DEFAULT NULL,
  FUNCTION_ID int(65) DEFAULT NULL,
  DATA_ACCESS_TYPE tinyint(65) DEFAULT NULL,
  DATA_ACCESS_POLICY varchar(128) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 207,
AVG_ROW_LENGTH = 712,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `FK_core_role_function_core_function_ID` on table `core_role_function`
--
ALTER TABLE core_role_function
ADD INDEX FK_core_role_function_core_function_ID (FUNCTION_ID);

--
-- Create index `FK_core_role_function_core_role_ID` on table `core_role_function`
--
ALTER TABLE core_role_function
ADD INDEX FK_core_role_function_core_role_ID (ROLE_ID);

--
-- Create table `core_role`
--
CREATE TABLE IF NOT EXISTS core_role (
  ID int(20) NOT NULL AUTO_INCREMENT,
  CODE varchar(32) DEFAULT NULL COMMENT '角色编码',
  NAME varchar(255) DEFAULT NULL COMMENT '角色名称',
  TYPE varchar(32) DEFAULT NULL COMMENT '1 可以配置 2 固定权限角色',
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 11,
AVG_ROW_LENGTH = 1638,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `code_idx` on table `core_role`
--
ALTER TABLE core_role
ADD INDEX code_idx (CODE);

--
-- Create table `core_org`
--
CREATE TABLE IF NOT EXISTS core_org (
  ID int(20) NOT NULL AUTO_INCREMENT,
  CODE varchar(16) NOT NULL,
  NAME varchar(16) NOT NULL,
  PARENT_ORG_ID int(20) DEFAULT NULL,
  TYPE varchar(16) NOT NULL COMMENT '1 公司，2 部门，3 小组',
  DEL_FLAG tinyint(6) DEFAULT NULL,
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 9,
AVG_ROW_LENGTH = 2340,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create table `core_menu`
--
CREATE TABLE IF NOT EXISTS core_menu (
  ID int(20) NOT NULL AUTO_INCREMENT,
  CODE varchar(32) DEFAULT NULL,
  NAME varchar(32) DEFAULT NULL,
  FUNCTION_ID int(20) DEFAULT NULL,
  TYPE varchar(16) DEFAULT NULL COMMENT '1,系统，2 导航 3 菜单项（对应某个功能点）',
  PARENT_MENU_ID int(20) DEFAULT NULL,
  SEQ int(20) DEFAULT NULL,
  ICON varchar(128) DEFAULT NULL COMMENT '图标',
  CREATE_TIME bigint(32) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 83,
AVG_ROW_LENGTH = 963,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create index `FK_core_menu_core_function_ID` on table `core_menu`
--
ALTER TABLE core_menu
ADD INDEX FK_core_menu_core_function_ID (FUNCTION_ID);

--
-- Create table `core_function`
--
CREATE TABLE IF NOT EXISTS core_function (
  ID int(20) NOT NULL AUTO_INCREMENT,
  CODE varchar(250) DEFAULT NULL,
  NAME varchar(32) DEFAULT NULL,
  ACCESS_URL varchar(250) DEFAULT NULL,
  PARENT_ID int(65) DEFAULT NULL,
  TYPE varchar(16) DEFAULT NULL,
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 184,
AVG_ROW_LENGTH = 819,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create table `core_file_tag`
--
CREATE TABLE IF NOT EXISTS core_file_tag (
  ID int(20) NOT NULL AUTO_INCREMENT,
  `KEY` varchar(64) NOT NULL COMMENT 'key，关键字',
  VALUE varchar(255) NOT NULL COMMENT '关键字对应的值',
  FILE_ID int(20) NOT NULL COMMENT 'sys_file的id，文件id',
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 3,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = '文件标签';

--
-- Create table `core_file`
--
CREATE TABLE IF NOT EXISTS core_file (
  ID int(20) NOT NULL AUTO_INCREMENT,
  NAME varchar(64) DEFAULT NULL COMMENT '文件名称',
  PATH varchar(255) DEFAULT NULL COMMENT '路径',
  BIZ_ID varchar(128) DEFAULT NULL COMMENT '业务ID',
  USER_ID int(20) DEFAULT NULL COMMENT '上传人id',
  ORG_ID int(20) DEFAULT NULL,
  BIZ_TYPE varchar(128) DEFAULT NULL,
  FILE_BATCH_ID varchar(128) DEFAULT NULL,
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 39,
AVG_ROW_LENGTH = 1489,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = '文件表';

--
-- Create table `core_dict`
--
CREATE TABLE IF NOT EXISTS core_dict (
  ID int(11) NOT NULL AUTO_INCREMENT,
  VALUE varchar(16) NOT NULL,
  NAME varchar(128) NOT NULL COMMENT '名称',
  TYPE varchar(64) NOT NULL COMMENT '字典编码',
  TYPE_NAME varchar(64) NOT NULL COMMENT '类型描述',
  SORT int(11) DEFAULT NULL COMMENT '排序',
  PARENT int(11) DEFAULT NULL COMMENT '父id',
  DEL_FLAG int(11) DEFAULT NULL COMMENT '删除标记',
  REMARK varchar(255) DEFAULT NULL COMMENT '备注',
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 33,
AVG_ROW_LENGTH = 512,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = '字典表';

--
-- Create index `idx_code` on table `core_dict`
--
ALTER TABLE core_dict
ADD INDEX idx_code (TYPE);

--
-- Create index `idx_pid` on table `core_dict`
--
ALTER TABLE core_dict
ADD INDEX idx_pid (PARENT);

--
-- Create index `idx_value` on table `core_dict`
--
ALTER TABLE core_dict
ADD INDEX idx_value (VALUE);

--
-- Create table `core_audit`
--
CREATE TABLE IF NOT EXISTS core_audit (
  ID int(11) NOT NULL AUTO_INCREMENT,
  FUNCTION_CODE varchar(45) DEFAULT NULL,
  FUNCTION_NAME varchar(45) DEFAULT NULL,
  USER_ID int(11) DEFAULT NULL,
  USER_NAME varchar(45) DEFAULT NULL,
  IP varchar(45) DEFAULT NULL,
  SUCCESS tinyint(4) DEFAULT NULL,
  MESSAGE varchar(250) DEFAULT NULL,
  ORG_ID varchar(45) DEFAULT NULL,
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (ID)
)
ENGINE = INNODB,
AUTO_INCREMENT = 46,
AVG_ROW_LENGTH = 364,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Create table `cms_blog`
--
CREATE TABLE IF NOT EXISTS cms_blog (
  id int(11) NOT NULL AUTO_INCREMENT,
  title varchar(255) DEFAULT NULL,
  content varchar(512) DEFAULT NULL,
  create_user_id int(11) DEFAULT NULL,
  type varchar(255) DEFAULT NULL,
  CREATE_TIME bigint(11) DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 3,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

-- 
-- Dumping data for table core_user_role
--
INSERT INTO core_user_role(ID, USER_ID, ROLE_ID, ORG_ID, CREATE_TIME) VALUES
(1, 3, 1, 4, NULL),
(2, 4, 2, 5, NULL),
(3, 75, 3, 6, 1505988185),
(35, 1, 1, 1, 1504631522),
(36, 1, 3, 6, 1504639985),
(38, 1, 1, 3, 1504640102),
(41, 1, 1, 5, 1504641482),
(42, 3, 3, 1, 1504641660),
(47, 47, 3, 1, 1504706401),
(49, 5, 3, 4, 1504706460),
(52, 47, 2, 1, 1504717922),
(53, 48, 3, 4, 1504718044),
(55, 68, 2, 3, 1504791723),
(125, 74, 1, 4, 1508204222),
(144, 74, 3, NULL, 1508230500),
(145, 67, 3, NULL, 1508230501),
(146, 73, 3, NULL, 1508230502),
(147, 22, 3, NULL, 1508230504),
(148, 68, 3, NULL, 1508230560),
(168, 72, 1, 3, 1508827204),
(169, 41, 1, NULL, 1508893081),
(171, 170, 1, 5, 1508893685),
(172, 171, 1, 4, 1517535401);

-- 
-- Dumping data for table core_user
--
INSERT INTO core_user(ID, CODE, NAME, PASSWORD, ORG_ID, STATE, JOB_TYPE1, DEL_FLAG, JOB_TYPE0, ATTACHMENT_ID, INTRODUCTION, AVATAR, UPDATE_TIME, CREATE_TIME) VALUES
(1, 'admin', '超级管理员1', '123456', 1, 'S1', 'JT_S_01', 0, 'JT_01', NULL, NULL, NULL, 1505265663, 1505265663),
(171, 'user01', '用户1', '123456', 3, 'S1', 'JT_S_04', 0, 'JT_02', NULL, NULL, NULL, NULL, 1517109681),
(172, 'user02', '用户2', '123456', 4, 'S1', 'JT_S_02', 0, 'JT_01', NULL, NULL, NULL, NULL, 1517109759),
(173, 'user03', '用户3', '123456', 5, 'S1', 'JT_S_04', 0, 'JT_02', NULL, NULL, NULL, NULL, 1517121895),
(174, 'user04', '用户4', '123456', 4, 'S1', 'JT_S_04', 0, 'JT_02', NULL, NULL, NULL, NULL, 1518752201),
(175, 'user05', '用户5', '123456', 3, 'S1', 'JT_S_04', 0, 'JT_02', '79b294da-8792-4bfd-9d84-e3f989b88cdf', NULL, NULL, NULL, 1520756362);

-- 
-- Dumping data for table core_role_menu
--
INSERT INTO core_role_menu(ID, ROLE_ID, MENU_ID, CREATE_TIME) VALUES
(1, 1, 5, NULL),
(2, 1, 11, NULL),
(3, 10, 5, NULL),
(4, 3, 5, NULL),
(5, 3, 16, NULL),
(6, 3, 5, NULL),
(7, 3, 6, NULL),
(8, 3, 8, NULL),
(9, 1, 2, NULL);

-- 
-- Dumping data for table core_role_function
--
INSERT INTO core_role_function(ID, ROLE_ID, FUNCTION_ID, DATA_ACCESS_TYPE, DATA_ACCESS_POLICY) VALUES
(1, 1, 1, 5, NULL),
(2, 1, 2, 4, NULL),
(3, 1, 3, 5, NULL),
(4, 2, 2, 2, NULL),
(5, 3, 2, 5, NULL),
(6, 3, 3, 5, NULL),
(7, 1, 4, NULL, NULL),
(8, 1, 15, NULL, NULL),
(9, 10, 1, NULL, NULL),
(10, 10, 2, 5, NULL),
(11, 10, 3, NULL, NULL),
(12, 10, 17, NULL, NULL),
(13, 3, 1, NULL, NULL),
(14, 3, 10, NULL, NULL),
(15, 3, 18, 3, NULL),
(16, 3, 1, NULL, NULL),
(17, 3, 2, NULL, NULL),
(18, 3, 3, NULL, NULL),
(19, 3, 4, NULL, NULL),
(20, 3, 15, NULL, NULL),
(21, 3, 6, NULL, NULL),
(22, 1, 20, NULL, NULL),
(23, 1, 19, NULL, NULL);

-- 
-- Dumping data for table core_role
--
INSERT INTO core_role(ID, CODE, NAME, TYPE, CREATE_TIME) VALUES
(1, 'DEPT_MANAGER', '部门管理员', 'R0', NULL),
(2, 'CEO', '公司CEO', 'R0', NULL),
(3, 'ASSIST', '助理', 'R0', NULL),
(4, '111', '2324324', 'R0', 1504642080),
(5, '1111', '哈哈', 'R0', 1504642145),
(6, 'admin', 'ivy', 'R0', 1504647304),
(7, '123', '我', 'R0', 1504704183),
(8, '23', '234', 'R0', 1504705263),
(9, '132484', '1', 'R0', 1504705322),
(10, 'dept.admin', '部门辅助管理员', 'R0', NULL);

-- 
-- Dumping data for table core_org
--
INSERT INTO core_org(ID, CODE, NAME, PARENT_ORG_ID, TYPE, DEL_FLAG, CREATE_TIME) VALUES
(1, '集团公司', '集团', NULL, 'ORGT0', 0, 1517563130),
(3, '信息科技部门', '信息科技部门', 1, 'ORGT2', 0, NULL),
(4, '贵州银行', '贵州银行', 1, 'ORGT1', 0, 1517563136),
(5, '贵州银行金科', '贵州银行金融科技开发公司', 4, 'ORGT1', 0, NULL),
(6, '金科研发', '金科研发', 5, 'ORGT2', 0, NULL),
(7, '金科研发部门', '金科研发部门', 6, 'ORGT2', 0, 1517809793),
(8, '金科研发2部', '金科研发2部', 6, 'ORGT2', 0, 1517809844);

-- 
-- Dumping data for table core_menu
--
INSERT INTO core_menu(ID, CODE, NAME, FUNCTION_ID, TYPE, PARENT_MENU_ID, SEQ, ICON, CREATE_TIME) VALUES
(1, '系统管理', '系统管理', 0, 'MENU_S', 0, 1, NULL, 0),
(2, '基础管理', '基础管理', 87, 'MENU_N', 1, 1, 'component', 0),
(3, '监控管理', '监控管理', 88, 'MENU_N', 1, 2, 'component', 0),
(4, '代码生成导航', '代码生成', 89, 'MENU_N', 1, 1, 'component', 1519868371),
(5, '用户管理', '用户管理', 1, 'MENU_M', 2, 1, '', 0),
(6, '组织机构管理', '组织机构管理', 4, 'MENU_M', 2, 2, NULL, 0),
(7, '角色管理', '角色管理', 5, 'MENU_M', 2, 3, NULL, 0),
(8, '菜单项', '菜单项', 6, 'MENU_M', 2, 4, NULL, 0),
(9, '功能点管理', '功能点管理', 7, 'MENU_M', 2, 5, NULL, 0),
(10, '字典数据管理', '字典数据管理', 12, 'MENU_M', 2, 6, NULL, 0),
(11, '角色功能授权', '角色功能授权', 8, 'MENU_M', 2, 8, NULL, 0),
(12, '角色数据授权', '角色数据授权', 9, 'MENU_M', 2, 9, NULL, 0),
(13, '审计查询', '审计查询', 13, 'MENU_M', 3, 7, NULL, 0),
(14, '流程监控', '流程监控', 17, 'MENU_M', 3, 3, NULL, 0),
(15, '博客测试', '博客测试1', 20, 'MENU_M', 3, 9, NULL, 0),
(16, '代码生成', '代码生成', 10, 'MENU_M', 4, 8, NULL, 0),
(17, '子系统生成', '子系统生成', 21, 'MENU_M', 4, 1, NULL, 1519868556),
(18, 'Permission', 'Permission', 22, 'MENU_M', 1, 999, 'lock', 1519868556),
(19, 'PagePermission', 'PagePermission', 23, 'MENU_M', 18, 999, NULL, 1519868556),
(20, 'DirectivePermission', 'DirectivePermission', 24, 'MENU_M', 18, 999, NULL, 1519868556),
(21, 'RolePermission', 'RolePermission', 25, 'MENU_M', 18, 999, NULL, 1519868556),
(22, 'Icon', 'Icon', 26, 'MENU_M', 1, 999, 'icon', 1519868556),
(23, 'Icons', 'Icons', 27, 'MENU_M', 22, 999, NULL, 1519868556),
(24, 'ComponentDemo', 'ComponentDemo', 28, 'MENU_M', 1, 999, 'component', 1519868556),
(25, 'TinymceDemo', 'TinymceDemo', 29, 'MENU_M', 24, 999, NULL, 1519868556),
(26, 'MarkdownDemo', 'MarkdownDemo', 30, 'MENU_M', 24, 999, NULL, 1519868556),
(27, 'JsonEditorDemo', 'JsonEditorDemo', 31, 'MENU_M', 24, 999, NULL, 1519868556),
(28, 'SplitpaneDemo', 'SplitpaneDemo', 32, 'MENU_M', 24, 999, NULL, 1519868556),
(29, 'AvatarUploadDemo', 'AvatarUploadDemo', 33, 'MENU_M', 24, 999, NULL, 1519868556),
(30, 'DropzoneDemo', 'DropzoneDemo', 34, 'MENU_M', 24, 999, NULL, 1519868556),
(31, 'StickyDemo', 'StickyDemo', 35, 'MENU_M', 24, 999, NULL, 1519868556),
(32, 'CountToDemo', 'CountToDemo', 36, 'MENU_M', 24, 999, NULL, 1519868556),
(33, 'ComponentMixinDemo', 'ComponentMixinDemo', 37, 'MENU_M', 24, 999, NULL, 1519868556),
(34, 'BackToTopDemo', 'BackToTopDemo', 38, 'MENU_M', 24, 999, NULL, 1519868556),
(35, 'DragDialogDemo', 'DragDialogDemo', 39, 'MENU_M', 24, 999, NULL, 1519868556),
(36, 'DragSelectDemo', 'DragSelectDemo', 40, 'MENU_M', 24, 999, NULL, 1519868556),
(37, 'DndListDemo', 'DndListDemo', 41, 'MENU_M', 24, 999, NULL, 1519868556),
(38, 'DragKanbanDemo', 'DragKanbanDemo', 42, 'MENU_M', 24, 999, NULL, 1519868556),
(39, 'Charts', 'Charts', 43, 'MENU_M', 1, 999, 'chart', 1519868556),
(40, 'KeyboardChart', 'KeyboardChart', 44, 'MENU_M', 39, 999, NULL, 1519868556),
(41, 'LineChart', 'LineChart', 45, 'MENU_M', 39, 999, NULL, 1519868556),
(42, 'MixChart', 'MixChart', 46, 'MENU_M', 39, 999, NULL, 1519868556),
(43, 'Nested', 'Nested', 47, 'MENU_M', 1, 999, 'nested', 1519868556),
(44, 'Menu1', 'Menu1', 48, 'MENU_M', 43, 999, NULL, 1519868556),
(45, 'Menu1-1', 'Menu1-1', 49, 'MENU_M', 44, 999, NULL, 1519868556),
(46, 'Menu1-2', 'Menu1-2', 50, 'MENU_M', 44, 999, NULL, 1519868556),
(47, 'Menu1-2-1', 'Menu1-2-1', 51, 'MENU_M', 46, 999, NULL, 1519868556),
(48, 'Menu1-2-2', 'Menu1-2-2', 52, 'MENU_M', 46, 999, NULL, 1519868556),
(49, 'Menu1-3', 'Menu1-3', 53, 'MENU_M', 44, 999, NULL, 1519868556),
(50, 'Menu2', 'Menu2', 54, 'MENU_M', 43, 999, NULL, 1519868556),
(51, 'Table', 'Table', 55, 'MENU_M', 1, 999, 'table', 1519868556),
(52, 'DynamicTable', 'DynamicTable', 56, 'MENU_M', 51, 999, NULL, 1519868556),
(53, 'DragTable', 'DragTable', 57, 'MENU_M', 51, 999, NULL, 1519868556),
(54, 'InlineEditTable', 'InlineEditTable', 58, 'MENU_M', 51, 999, NULL, 1519868556),
(55, 'ComplexTable', 'ComplexTable', 59, 'MENU_M', 51, 999, NULL, 1519868556),
(56, 'Example', 'Example', 60, 'MENU_M', 1, 999, 'example', 1519868556),
(57, 'CreateArticle', 'CreateArticle', 61, 'MENU_M', 56, 999, 'edit', 1519868556),
(58, 'EditArticle', 'EditArticle', 62, 'MENU_M', 56, 999, NULL, 1519868556),
(59, 'ArticleList', 'ArticleList', 63, 'MENU_M', 56, 999, 'list', 1519868556),
(60, 'Tab', 'Tab', 64, 'MENU_M', 1, 999, 'tab', 1519868556),
(61, 'Tabs', 'Tabs', 65, 'MENU_M', 60, 999, NULL, 1519868556),
(62, 'ErrorPages', 'ErrorPages', 66, 'MENU_M', 1, 999, '404', 1519868556),
(63, 'Page401', 'Page401', 67, 'MENU_M', 62, 999, NULL, 1519868556),
(64, 'Page404', 'Page404', 68, 'MENU_M', 62, 999, NULL, 1519868556),
(65, 'ErrorLog', 'ErrorLog', 69, 'MENU_M', 1, 999, 'bug', 1519868556),
(66, 'ErrorLogs', 'ErrorLogs', 70, 'MENU_M', 65, 999, NULL, 1519868556),
(67, 'Excel', 'Excel', 71, 'MENU_M', 1, 999, 'excel', 1519868556),
(68, 'ExportExcel', 'ExportExcel', 72, 'MENU_M', 67, 999, NULL, 1519868556),
(69, 'SelectExcel', 'SelectExcel', 73, 'MENU_M', 67, 999, NULL, 1519868556),
(70, 'MergeHeader', 'MergeHeader', 74, 'MENU_M', 67, 999, NULL, 1519868556),
(71, 'UploadExcel', 'UploadExcel', 75, 'MENU_M', 67, 999, NULL, 1519868556),
(72, 'Zip', 'Zip', 76, 'MENU_M', 1, 999, 'zip', 1519868556),
(73, 'ExportZip', 'ExportZip', 77, 'MENU_M', 72, 999, NULL, 1519868556),
(74, 'PDF', 'PDF', 78, 'MENU_M', 1, 999, 'pdf', 1519868556),
(75, 'PDFS', 'PDFS', 79, 'MENU_M', 74, 999, NULL, 1519868556),
(76, 'PdfDown', 'PdfDown', 80, 'MENU_M', 1, 999, NULL, 1519868556),
(77, 'Theme', 'Theme', 81, 'MENU_M', 1, 999, 'theme', 1519868556),
(78, 'Themes', 'Themes', 82, 'MENU_M', 77, 999, NULL, 1519868556),
(79, 'Clipboard', 'Clipboard', 83, 'MENU_M', 1, 999, 'clipboard', 1519868556),
(80, 'ClipboardDemo', 'ClipboardDemo', 84, 'MENU_M', 79, 999, NULL, 1519868556),
(81, 'ExternalLink', 'ExternalLink', 85, 'MENU_M', 1, 999, 'link', 1519868556),
(82, 'link', 'link', 86, 'MENU_M', 81, 999, NULL, 1519868556);

-- 
-- Dumping data for table core_function
--
INSERT INTO core_function(ID, CODE, NAME, ACCESS_URL, PARENT_ID, TYPE, CREATE_TIME) VALUES
(0, 'system', '系统管理', '/system', 0, 'FN2', 0),
(1, 'user', '用户功能', '/admin/user/index.do', 0, 'FN2', 0),
(2, 'user.query', '用户列表', NULL, 1, 'FN1', 0),
(3, 'user.edit', '用户编辑', NULL, 1, 'FN1', 0),
(4, 'org', '组织机构', '/admin/org/index.do', 0, 'FN2', 0),
(5, 'role', '角色管理', '/admin/role/index.do', 0, 'FN2', 0),
(6, 'menu', '菜单管理', '/admin/menu/index.do', 0, 'FN2', 0),
(7, 'function', '功能点管理', '/admin/function/index.do', 0, 'FN2', 0),
(8, 'roleFunction', '角色功能授权', '/admin/role/function.do', 0, 'FN2', 0),
(9, 'roleDataAccess', '角色数据授权', '/admin/role/data.do', 0, 'FN2', 0),
(10, 'code', '代码生成', '/core/codeGen/index.do', 0, 'FN2', 0),
(12, 'dict', '字典管理', '/admin/dict/index.do', 0, 'FN2', 0),
(13, 'trace', '审计查询', '/admin/audit/index.do', 0, 'FN2', 0),
(14, 'file', '相关文档', '/trade/interAndRelate/file.do', 0, 'FN2', 0),
(15, 'test', '测试', '/test/test.do', 0, 'FN2', 1507712341),
(16, 'role.add', '角色添加', NULL, 4, 'FN2', 1508723105),
(17, 'workflow.admin', '工作流监控', '/admin/workflow/index.do', 0, 'FN2', 0),
(18, 'code.query', '代码生成测试', NULL, 10, 'FN2', 0),
(19, 'blog.query', '博客查询功能', NULL, 20, 'FN2', 0),
(20, 'blog', '博客测试', '/admin/blog/index.do', 0, 'FN2', 0),
(21, 'code.project', '项目生成', '/core/codeGen/project.do', 10, 'FN2', 1519868297),
(22, 'permission', 'Permission', '/permission', 0, 'FN2', 1519868556),
(23, 'permission.page', 'PagePermission', 'page', 22, 'FN2', 1519868556),
(24, 'permission.directive', 'DirectivePermission', 'directive', 22, 'FN2', 1519868556),
(25, 'permission.role', 'RolePermission', 'role', 22, 'FN2', 1519868556),
(26, 'icon', 'Icon', '/icon', 0, 'FN2', 1519868556),
(27, 'icon.index', 'Icons', 'index', 26, 'FN2', 1519868556),
(28, 'component', 'ComponentDemo', '/components', 28, 'FN2', 1519868556),
(29, 'component.tinymce', 'TinymceDemo', 'tinymce', 28, 'FN2', 1519868556),
(30, 'component.markdown', 'MarkdownDemo', 'markdown', 28, 'FN2', 1519868556),
(31, 'component.json-editor', 'JsonEditorDemo', 'json-editor', 28, 'FN2', 1519868556),
(32, 'component.splitpane', 'SplitpaneDemo', 'split-pane', 28, 'FN2', 1519868556),
(33, 'component.avatar-upload', 'AvatarUploadDemo', 'avatar-upload', 28, 'FN2', 1519868556),
(34, 'component.dropzone', 'DropzoneDemo', 'dropzone', 28, 'FN2', 1519868556),
(35, 'component.sticky', 'StickyDemo', 'sticky', 28, 'FN2', 1519868556),
(36, 'component.count-to', 'CountToDemo', 'count-to', 28, 'FN2', 1519868556),
(37, 'component.mixin', 'ComponentMixinDemo', 'mixin', 28, 'FN2', 1519868556),
(38, 'component.back-to-top', 'BackToTopDemo', 'back-to-top', 28, 'FN2', 1519868556),
(39, 'component.drag-dialog', 'DragDialogDemo', 'drag-dialog', 28, 'FN2', 1519868556),
(40, 'component.drag-select', 'DragSelectDemo', 'drag-select', 28, 'FN2', 1519868556),
(41, 'component.dnd-list', 'DndListDemo', 'dnd-list', 28, 'FN2', 1519868556),
(42, 'component.drag-kanban', 'DragKanbanDemo', 'drag-kanban', 28, 'FN2', 1519868556),
(43, 'chart', 'Charts', '/charts', 0, 'FN2', 1519868556),
(44, 'chart.keyboard', 'KeyboardChart', 'keyboard', 43, 'FN2', 1519868556),
(45, 'chart.line', 'LineChart', 'line', 43, 'FN2', 1519868556),
(46, 'chart.mix', 'MixChart', 'mix-chart', 43, 'FN2', 1519868556),
(47, 'nested', 'Nested', '/nested', 0, 'FN2', 1519868556),
(48, 'nested.menu1', 'Menu1', 'menu1', 47, 'FN2', 1519868556),
(49, 'nested.menu1-1', 'Menu1-1', 'menu1-1', 47, 'FN2', 1519868556),
(50, 'nested.menu1-2', 'Menu1-2', 'menu1-2', 47, 'FN2', 1519868556),
(51, 'nested.menu1-2-1', 'Menu1-2-1', 'menu1-2-1', 47, 'FN2', 1519868556),
(52, 'nested.menu1-2-2', 'Menu1-2-2', 'menu1-2-2', 47, 'FN2', 1519868556),
(53, 'nested.menu1-3', 'Menu1-3', 'menu1-3', 47, 'FN2', 1519868556),
(54, 'nested.menu2', 'Menu2', 'menu2', 47, 'FN2', 1519868556),
(55, 'table', 'Table', '/table', 0, 'FN2', 1519868556),
(56, 'table.dynamic', 'DynamicTable', 'dynamic-table', 55, 'FN2', 1519868556),
(57, 'table.drag', 'DragTable', 'drag-table', 55, 'FN2', 1519868556),
(58, 'table.inline-edit', 'InlineEditTable', 'inline-edit-table', 55, 'FN2', 1519868556),
(59, 'table.complex', 'ComplexTable', 'complex-table', 55, 'FN2', 1519868556),
(60, 'example', 'Example', '/example', 0, 'FN2', 1519868556),
(61, 'example.create-article', 'CreateArticle', 'create', 60, 'FN2', 1519868556),
(62, 'example.edit-article', 'EditArticle', 'edit/:id(\\d+)', 60, 'FN2', 1519868556),
(63, 'example.article-list', 'ArticleList', 'list', 60, 'FN2', 1519868556),
(64, 'tab', 'Tab', '/tab', 0, 'FN2', 1519868556),
(65, 'tab.index', 'Tabs', 'index', 64, 'FN2', 1519868556),
(66, 'error-page', 'ErrorPages', '/error', 0, 'FN2', 1519868556),
(67, 'error-page.401', 'Page401', '401', 66, 'FN2', 1519868556),
(68, 'error-page.404', 'Page404', '404', 66, 'FN2', 1519868556),
(69, 'error-log', 'ErrorLog', '/error-log', 0, 'FN2', 1519868556),
(70, 'error-log.index', 'ErrorLogs', 'log', 69, 'FN2', 1519868556),
(71, 'excel', 'Excel', '/excel', 0, 'FN2', 1519868556),
(72, 'excel.export-excel', 'ExportExcel', 'export-excel', 71, 'FN2', 1519868556),
(73, 'excel.select-excel', 'SelectExcel', 'export-selected-excel', 71, 'FN2', 1519868556),
(74, 'excel.merge-header', 'MergeHeader', 'export-merge-header', 71, 'FN2', 1519868556),
(75, 'excel.upload-excel', 'UploadExcel', 'upload-excel', 71, 'FN2', 1519868556),
(76, 'zip', 'Zip', '/zip', 0, 'FN2', 1519868556),
(77, 'zip.down', 'ExportZip', 'download', 76, 'FN2', 1519868556),
(78, 'pdf', 'PDF', '/pdf', 0, 'FN2', 1519868556),
(79, 'pdf.index', 'PDFS', 'index', 78, 'FN2', 1519868556),
(80, 'pdf-down', 'PdfDown', '/pdf/download', 78, 'FN2', 1519868556),
(81, 'theme', 'Theme', '/theme', 0, 'FN2', 1519868556),
(82, 'theme.index', 'Themes', 'index', 81, 'FN2', 1519868556),
(83, 'clipboard', 'Clipboard', '/clipboard', 0, 'FN2', 1519868556),
(84, 'clipboard.index', 'ClipboardDemo', 'index', 83, 'FN2', 1519868556),
(85, 'external-link', 'ExternalLink', 'external-link', 0, 'FN2', 1519868556),
(86, 'external-link.link', 'Link', 'https://github.com/PanJiaChen/vue-element-admin', 86, 'FN2', 1519868556),
(87, 'admin', '基础管理', '/admin', 0, 'FN2', 1519868556),
(88, 'monitor', '监控管理', '/monitor', 0, 'FN2', 1519868556),
(89, 'code', '代码生成', '/code', 0, 'FN2', 1519868556);

-- 
-- Dumping data for table core_file_tag
--
INSERT INTO core_file_tag(ID, `KEY`, VALUE, FILE_ID) VALUES
(1, 'customer', '12332', 1),
(2, 'type', 'crdit', 2);

-- 
-- Dumping data for table core_file
--
INSERT INTO core_file(ID, NAME, PATH, BIZ_ID, USER_ID, ORG_ID, BIZ_TYPE, FILE_BATCH_ID, CREATE_TIME) VALUES
(19, 'dict_upload_template.xls', '20180311/dict_upload_template.xls.8caa38fb-52ef-4c73-85ea-abfb1f5c5dc4', NULL, 1, 1, NULL, '18c0dd67-e334-47ba-8969-915bcf77c544', 1520753819),
(20, 'dict_upload_template.xls', '20180311/dict_upload_template.xls.f50b7f0f-d376-4a95-be6a-14f5aa4a81e6', NULL, 1, 1, NULL, '335a583a-9c74-462d-be0a-5a82d427b1aa', 1520753836),
(21, 'dict_upload_template.xls', '20180311/dict_upload_template.xls.b0b9434d-e367-43ef-b8ac-366cf7b018b6', NULL, 1, 1, NULL, 'a5b887c6-101c-46e8-b9e2-b3b448edff34', 1520753933),
(22, 'dict_upload_template.xls', '20180311/dict_upload_template.xls.15f02d15-2dd0-4cb7-b2e5-4f7d72fb497d', NULL, 1, 1, NULL, '833d96bc-797c-403f-aa2e-00e2b5a3cd71', 1520753942),
(23, 'dict_upload_template.xls', '20180311/dict_upload_template.xls.f12350bc-31da-4875-a78e-0135f512fb4c', NULL, 1, 1, NULL, '0b2a66a3-8aa8-46b7-8bf0-ce9f68041cd8', 1520754112),
(24, 'dict_upload_template.xls', '20180311/dict_upload_template.xls.5bf626e5-2152-45a5-a432-fc2e9fcb7903', NULL, 1, 1, NULL, '813725ab-2c07-4e48-a766-7ebbe3083212', 1520754198),
(25, 'dict_upload_template.xls', '20180311/dict_upload_template.xls.3cd3eb95-aab9-4105-8d28-76a723274709', NULL, 1, 1, NULL, '4216455c-20d7-4912-bfc8-c8cca7e70e9f', 1520754238),
(26, 'dict_upload_template.xls', '20180311/dict_upload_template.xls.d3dc557b-1e77-4955-a3be-7a8b4f86407c', NULL, 1, 1, NULL, 'e42dc975-edd5-4d16-8529-fa69b56a5eb5', 1520754303),
(34, 'dict_upload_template.xls', '20180311/dict_upload_template.xls.d50f8245-ec3e-4de1-9742-0c5c12105f27', '175', 1, 1, NULL, '79b294da-8792-4bfd-9d84-e3f989b88cdf', 1520757036),
(37, '副本 功能列表.xlsx', '20180311/副本 功能列表.xlsx.bc7554e3-2a30-4667-aa61-0e280340b2be', '175', 1, 1, 'User', '79b294da-8792-4bfd-9d84-e3f989b88cdf', 1520765622),
(38, '副本 功能列表.xlsx', '20180311/副本 功能列表.xlsx.d991eb1f-24a9-4db1-87c1-7ef9d2b8a40a', '175', 1, 1, 'User', '79b294da-8792-4bfd-9d84-e3f989b88cdf', 1520777458);

-- 
-- Dumping data for table core_dict
--
INSERT INTO core_dict(ID, VALUE, NAME, TYPE, TYPE_NAME, SORT, PARENT, DEL_FLAG, REMARK, CREATE_TIME) VALUES
(1, 'DA0', '查看自己', 'data_access_type', '数据权限', 1, NULL, 0, '11111111111111111123', NULL),
(2, 'DA1', '查看本公司', 'data_access_type', '数据权限', 3, NULL, 0, 'hello,go', NULL),
(3, 'DA2', '查看同机构', 'data_access_type', '数据权限', 3, NULL, 0, NULL, NULL),
(4, 'DA3', '查看本部门', 'data_access_type', '数据权限', 4, NULL, 0, NULL, NULL),
(5, 'DA4', '查看集团', 'data_access_type', '数据权限', 5, NULL, 0, NULL, NULL),
(6, 'DA5', '查看母公司', 'data_access_type', '数据权限', 6, NULL, 0, NULL, 1507952702),
(7, 'FN0', '普通功能', 'function_type', '功能点类型', 2, NULL, 0, '除菜单访问的路径和数据权限的路径请求之外的都是普通功能', 1508725083),
(8, 'FN1', '含数据权限', 'function_type', '功能点类型', 1, NULL, 0, NULL, 1508725205),
(9, 'JT_01', '管理岗位', 'job_type', '岗位类型', 1, NULL, 0, NULL, NULL),
(10, 'JT_02', '技术岗位', 'job_type', '岗位类型', 2, NULL, 0, NULL, NULL),
(11, 'JT_S_01', '董事会', 'job_sub_managment_type', '管理岗位子类型', 1, 9, 0, NULL, NULL),
(12, 'JT_S_02', '秘书', 'job_sub_managment_type', '管理岗位子类型', 2, 9, 0, NULL, NULL),
(13, 'JT_S_03', '技术经理', 'job_dev_sub_type', '技术岗位子类型', 1, 10, 0, NULL, NULL),
(14, 'JT_S_04', '程序员', 'job_dev_sub_type', '技术岗位子类型', 2, 10, 0, NULL, NULL),
(15, 'MENU_M', '菜单', 'menu_type', '菜单类型', 3, NULL, 0, NULL, NULL),
(16, 'MENU_N', '导航', 'menu_type', '菜单类型', 2, NULL, 0, NULL, NULL),
(17, 'MENU_S', '系统', 'menu_type', '菜单类型', 1, NULL, 0, NULL, NULL),
(18, 'ORGT0', '集团总部', 'org_type', '机构类型', 1, NULL, 0, NULL, NULL),
(19, 'ORGT1', '分公司', 'org_type', '机构类型', 2, NULL, 0, NULL, NULL),
(20, 'ORGT2', '部门', 'org_type', '机构类型', 3, NULL, 0, NULL, NULL),
(21, 'ORGT3', '小组', 'org_type', '机构类型', 4, NULL, 0, NULL, NULL),
(22, 'R0', '操作角色', 'role_type', '数据权限', 1, NULL, 0, NULL, NULL),
(23, 'R1', '工作流角色', 'role_type', '用户角色', 2, NULL, 0, NULL, NULL),
(24, 'S0', '禁用', 'user_state', '用户状态', 2, NULL, 0, NULL, NULL),
(25, 'S1', '启用', 'user_state', '用户状态', 1, NULL, 0, NULL, NULL),
(26, '1', '男', 'gender', '性别', NULL, NULL, 0, NULL, 1520652980),
(27, '2', '女', 'gender', '性别', NULL, NULL, 0, NULL, 1520652980),
(28, 'FN2', '菜单功能', 'function_type', '功能点类型', 3, NULL, 0, '凡是menu_type的菜单类型的请求都是菜单功能', NULL);

-- 
-- Dumping data for table core_audit
--
INSERT INTO core_audit(ID, FUNCTION_CODE, FUNCTION_NAME, USER_ID, USER_NAME, IP, SUCCESS, MESSAGE, ORG_ID, CREATE_TIME) VALUES
(1, 'org.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517918331),
(2, 'org.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517918331),
(3, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517918411),
(4, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517918411),
(5, 'user.add', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517918440),
(6, 'user.edit', '用户编辑', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517919015),
(7, 'user.query', '用户列表', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517919016),
(8, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517919017),
(9, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517919017),
(10, 'user.edit', '用户编辑', 1, '超级管理员', '172.16.49.65', 0, 'java.sql.SQLException: Error on delete of ''C:\\Users\\ADMINI~1\\AppData\\Local\\Temp\\#sql978_2c3_6.MYI'' (Errcode: 13 - Permission denied)', NULL, 1517919287),
(11, 'user.edit', '用户编辑', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517919313),
(12, 'user.query', '用户列表', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517919313),
(13, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517919315),
(14, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517919315),
(15, 'audit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517919384),
(16, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517967778),
(17, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517967778),
(18, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968392),
(19, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968392),
(20, 'user.add', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968393),
(21, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968409),
(22, 'role.add', '角色添加', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968409),
(23, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968423),
(24, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968423),
(25, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968425),
(26, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968563),
(27, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968564),
(28, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968566),
(29, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968568),
(30, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968570),
(31, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968571),
(32, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968921),
(33, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968921),
(34, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517968923),
(35, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969140),
(36, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969140),
(37, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969142),
(38, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969162),
(39, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969265),
(40, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969266),
(41, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969268),
(42, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969283),
(43, 'role.update', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969283),
(44, 'role.edit', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969297),
(45, 'role.query', '未定义', 1, '超级管理员', '172.16.49.65', 1, '', NULL, 1517969297);

-- 
-- Dumping data for table cms_blog
--
INSERT INTO cms_blog(id, title, content, create_user_id, type, CREATE_TIME) VALUES
(1, 'hello', '我的博客，内容是。。。', 1, 'F0', 1519264385),
(2, 'cccc', '过年回家', 1, 'F0', 1518489001);

-- 
-- Restore previous SQL mode
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Enable foreign keys
-- 
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;