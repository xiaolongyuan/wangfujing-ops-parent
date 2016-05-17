package com.wangfj.wms.persistence;


import java.util.List;

import com.framework.persistence.WangfjMysqlMapper;
import com.wangfj.wms.domain.entity.RoleChannel;

@WangfjMysqlMapper
public interface RoleChannelMapper {
	/**
	 * 删除roles和channel的对应关系
	 */
	int deleteByParamter(RoleChannel record);
	
	void deleteByRoleSid(Long sid);
	
    int insert(RoleChannel record);

    int insertSelective(RoleChannel record);
    
    List selectList(RoleChannel record);
    
    List selectAllRoleChannel();
}