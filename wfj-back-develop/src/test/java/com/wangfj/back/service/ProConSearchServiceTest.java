/**
 * @Probject Name: shopin-back-demo
 * @Path: com.wangfj.back.serviceProConSearchServiceTest.java
 * @Create By chengsj
 * @Create In 2013-5-10 下午1:49:17
 * TODO
 */
package com.wangfj.back.service;

import java.sql.SQLException;

import org.junit.Before;
import org.junit.Test;
import org.springframework.util.Assert;

import com.framework.page.Paginator;
import com.framework.returnObj.Infos;
import com.framework.testCase.AbstractTest;
import com.utils.JsonUtil;
import com.wangfj.back.entity.cond.ProConSearchCond;
import com.wangfj.back.entity.po.ProConSearch;
import com.wangfj.back.entity.vo.ProConSearchVO;
import com.wangfj.back.service.impl.ProConSearchServiceImpl;
import com.wangfj.back.view.ProductKey;

/**
 * @Class Name ProConSearchServiceTest
 * @Author chengsj
 * @Create In 2013-5-10
 */
public class ProConSearchServiceTest extends AbstractTest{
	
	IProConSearchService proConSearchService;
	
	@Before
	public void setUp() throws Exception{
		super.setUp();
		this.proConSearchService = context.getBean(ProConSearchServiceImpl.class);
		Assert.notNull(this.proConSearchService);
	}
	
	//@Test
	public void testFindObjBySid() throws SQLException{
		System.out.println("test");
		Infos infos = new Infos("", "", "", "");
		ProConSearchVO vo = this.proConSearchService.findObjBySid(infos,25191L);
		System.out.println(vo);
	}
	
	//@Test
	public void testQueryObjs() throws SQLException{
		Infos infos = new Infos("", "", "", "");
		ProConSearchCond cond = new ProConSearchCond();
		cond.setOffMin(0.2);
		cond.setStartRecords(1);
		cond.setEndRecords(10);
		Paginator page =  this.proConSearchService.queryObjs(infos, cond);
		System.out.println(page);
		String json = JsonUtil.Object2Json(page);
		System.out.println(json);
		
	}
	
	//@Test
	public void testInsert() throws SQLException{
		Infos infos = new Infos("", "", "", "");
		ProConSearchCond cond = new ProConSearchCond();
		ProConSearch record = new ProConSearch();
		record.setProSku("test");
		//record.setSid(25099L);
		cond.setProConSearch(record);
		this.proConSearchService.insert(infos, cond);
	}
	
	/**
	 * 25220
	 * @throws SQLException 
	 * @Methods Name testUpdate
	 * @Create In 2013-5-10 By chengsj void
	 */
	//@Test
	public void testUpdate() throws SQLException{
		Infos infos = new Infos("", "", "", "");
		ProConSearchCond cond = new ProConSearchCond();
		ProConSearch record = new ProConSearch();
		record.setProSku("testsku");
		record.setSid(25220L);
		cond.setProConSearch(record);
		this.proConSearchService.update(infos, cond);
	}
	
	//@Test
	public void testDelete() throws SQLException{
		Infos infos = new Infos("", "", "", "");
		ProConSearchCond cond = new ProConSearchCond();
		ProConSearch record = new ProConSearch();
//		record.setProSku("testsku");
		record.setSid(25220L);
		cond.setProConSearch(record);
		this.proConSearchService.delete(infos,25220L);
	}
	@Test
	public void testupdateProConSearch() throws SQLException{
		ProductKey productKey=new ProductKey();
		productKey.setSaleCodeSid("14321416");
		productKey.setOffMin("0.11");
		productKey.setOffMax("0.32");
		productKey.setPageLayoutSid("11225");
		this.proConSearchService.updateProConSearch(productKey);
	}
	
	
	
	
	
	

}
