select @maxid:= Max(id) from spider_goods;
select @ndate:= DATE_FORMAT(NOW(),'%Y%m%d') ;
select @seldate:= DATE_FORMAT(NOW(),'%Y-%m-%d') ;

SET @sqlcreatetmp = CONCAT("CREATE TABLE `spider_goods_tmp` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '货物编号，非空、主键',
  `website` varchar(50) NOT NULL DEFAULT '' COMMENT '抓取源',
  `source_url` varchar(256) CHARACTER SET macroman NOT NULL DEFAULT '' COMMENT '如果抓取源为网站，该字段为网址；抓取源为APP则该字段为空',
  `depart_province` varchar(50) NOT NULL DEFAULT '' COMMENT '货源出发地（省）',
  `depart_city` varchar(50) NOT NULL DEFAULT '' COMMENT '货源出发地（市）',
  `depart_area` varchar(50) NOT NULL DEFAULT '' COMMENT '货源出发地（区）',
  `dest_province` varchar(50) NOT NULL DEFAULT '' COMMENT '货源目的地（省）',
  `dest_city` varchar(50) NOT NULL DEFAULT '' COMMENT '货源目的地（市）',
  `dest_area` varchar(50) NOT NULL DEFAULT '' COMMENT '货源目的地（区）',
  `goods_name` varchar(50) NOT NULL DEFAULT '' COMMENT '货物名称',
  `goods_volume` varchar(50) NOT NULL DEFAULT '' COMMENT '货物体积',
  `transport_type` varchar(50) NOT NULL DEFAULT '',
  `contact_person` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人',
  `contact_tel` varchar(50) NOT NULL DEFAULT '' COMMENT '联系电话',
  `goods_type` varchar(50) NOT NULL DEFAULT '' COMMENT '货物类型',
  `goods_weight` varchar(50) NOT NULL DEFAULT '' COMMENT '货物重量',
  `end_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '货源时效时间',
  `pub_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '货源发布时间',
  `publish_company_name` varchar(256) NOT NULL DEFAULT '' COMMENT '发布货源公司的名称',
  `publish_company_address` varchar(512) NOT NULL DEFAULT '' COMMENT '发布货源公司的地址',
  `publish_company_person` varchar(50) NOT NULL DEFAULT '' COMMENT '发布货源公司的联系人',
  `publish_company_tel` varchar(50) NOT NULL DEFAULT '' COMMENT '发布货源公司的联系电话',
  `publish_company_link` varchar(256) NOT NULL DEFAULT '' COMMENT '发布货源公司的网址',
  `note` varchar(2000) NOT NULL DEFAULT '' COMMENT '备注',
  `msg_title` varchar(256) NOT NULL DEFAULT '' COMMENT '货源描述',
  `views` int(11) NOT NULL DEFAULT '0',
  `remark` varchar(256) NOT NULL DEFAULT '',
  `createtime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '入库时间',
  `ishandled` int(11) NOT NULL DEFAULT '0' COMMENT '货源被分析的标记',
  `contact_phone` varchar(50) NOT NULL DEFAULT '',
  `ineunke` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否被存入自有数据库',
  `longitude` double NOT NULL DEFAULT '0' COMMENT '取一出发地，获取到的经度',
  `latitude` double NOT NULL DEFAULT '0' COMMENT '取一出发地(同经度)，获取到的纬度',
  `isclean` int(11) NOT NULL DEFAULT '0',
  `org_id` int(20) DEFAULT '0' COMMENT '数据所在原始数据表中的id',
  `is_valid` tinyint(4) DEFAULT '1' COMMENT '0: 无效 1:有效',
  `expectCarType` varchar(45) DEFAULT '' COMMENT '期望的车类型',
  `expectCarLength` varchar(45) DEFAULT '' COMMENT '期望的车长',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT =" ,@maxid, " DEFAULT CHARSET=utf8");

prepare stmt from @sqlcreatetmp; 
execute stmt; 

SET @sqlinsert1 = concat("INSERT INTO spider_goods_tmp (select * from spider_goods where date_format(`createtime` ,'%Y-%m-%d') ='",@seldate,"')");
prepare stmt from @sqlinsert1; 
execute stmt; 
SET @sqlinsert2 = concat("insert into spider_goods_tmp (select * from spider_goods where end_time > now() and  date_format(createtime ,'%Y-%m-%d') <> '",@seldate,"')");
prepare stmt from @sqlinsert2; 
execute stmt; 
SET @sqlrename = concat('RENAME TABLE spider_goods TO spider_goods_',@ndate,',spider_goods_tmp TO spider_goods');
prepare stmt from @sqlrename; 
execute stmt; 
SET @sqldelete =  concat('delete from spider_goods_' ,@ndate,' where id in (select id from spider_goods)');
prepare stmt from @sqldelete; 
execute stmt; 
