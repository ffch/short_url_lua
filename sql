DROP TABLE IF EXISTS `t_short_url`;
CREATE TABLE `t_short_url`  (
  `id` int(10) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
  `surl` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `hash` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `surl`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE `short_seq` (
  `sequence_name` varchar(64) NOT NULL COMMENT '序列名称',
  `value` int(11) DEFAULT NULL COMMENT '当前值',
  PRIMARY KEY (`sequence_name`)
) 


CREATE DEFINER = CURRENT_USER FUNCTION `nextval`(seq_name VARCHAR(50)) 
RETURNS int(11)
DETERMINISTIC
BEGIN  
   declare current integer;
    set current = 0;
    
    select t.value into current from short_seq t where t.sequence_name = sequence_name for update;
    update short_seq t set t.value = t.value + 1 where t.sequence_name = sequence_name;
    set current = current + 1;

    return current;
END;


select nextval('short') as id
