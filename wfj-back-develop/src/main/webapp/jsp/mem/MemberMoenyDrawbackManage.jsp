<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!--Page Related Scripts-->
<html>
<head>
<%request.setAttribute("ctx", request.getContextPath());%>
<script src="${pageContext.request.contextPath}/js/pagination/myPagination/jquery.myPagination6.0.js">  </script> 
<script src="${pageContext.request.contextPath}/js/pagination/msgbox/msgbox.js">  </script> 
<script src="${pageContext.request.contextPath}/js/pagination/jTemplates/jquery-jtemplates.js" >   </script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pagination/msgbox/msgbox.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pagination/myPagination/page.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/dateTime/datePicker.css"/>
<!--Bootstrap Date Range Picker-->
<script src="${ctx}/assets/js/datetime/moment.js"></script>
<script src="${ctx}/assets/js/datetime/daterangepicker.js"></script>
<style type="text/css">
.trClick>td,.trClick>th{
 color:red;
}
</style>
<script type="text/javascript">
//上下文路径
__ctxPath = "${pageContext.request.contextPath}";

//页码
var olvPagination;
//var format=new RegExp("^(((01[0-9]{2}|0[2-9][0-9]{2}|[1-9][0-9]{3})/(0?[13578]|1[02])/(0?[1-9]|[12]\\d|3[01]))|((01[0-9]{2}|0[2-9][0-9]{2}|[1-9][0-9]{3})/(0?[13456789]|1[012])/(0?[1-9]|[12]\\d|30))|((01[0-9]{2}|0[2-9][0-9]{2}|[1-9][0-9]{3})/0?2/(0?[1-9]|1\\d|2[0-8]))|(((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((04|08|12|16|[2468][048]|[3579][26])00))/0?2-29)) (20|21|22|23|[0-1]?\\d):[0-5]?\\d:[0-5]?\\d$");
//只做了简单的日期格式效验(不能效验瑞年) 格式为  yyyy-MM-dd hh:mm:ss 年月日分隔符可以为(-和/)  
var format=/^[\s]*[\d]{4}(\/|-)(0?[1-9]|1[012])(\/|-)(0?[1-9]|[12][0-9]|30|31)[\s]*(0?[0-9]|1[0-9]|2[0-3])(:([0-5][0-9])){2}[\s]*$/;
//初始时间选择器
function timePickInit(){
	/* var endTime=new Date();
	var startTime=new Date();
	startTime.setDate(endTime.getDate()-30);
	$('#applyTime').daterangepicker({
		startDate:endTime,
//		endDate:endTime,
		timePicker:true,
		timePickerSeconds:true,
		timePicker24Hour:true,
//		minDate:startTime,
//		maxDate:endTime,
//		linkedCalendars:false,
		opens:'center',
		showDropdowns : true,
		locale : {
		  	format: "YYYY-MM-DD HH:mm:ss",
          applyLabel : '确定',
          cancelLabel : '取消',
          fromLabel : '起始时间',
          toLabel : '结束时间',
          customRangeLabel : '自定义',
          daysOfWeek : [ '日', '一', '二', '三', '四', '五', '六' ],
          monthNames : [ '一月', '二月', '三月', '四月', '五月', '六月',
              '七月', '八月', '九月', '十月', '十一月', '十二月' ],
          firstDay : 1
      },
		singleDatePicker:true}); */
	$('#applyTime').daterangepicker({
		timePicker: true,
		timePickerIncrement: 30,
		format: 'YYYY/MM/DD HH:mm:ss',
        locale : {
            applyLabel : '确定',
            cancelLabel : '取消',
            fromLabel : '起始时间',
            toLabel : '结束时间',
            customRangeLabel : '自定义',
            daysOfWeek : [ '日', '一', '二', '三', '四', '五', '六' ],
            monthNames : [ '一月', '二月', '三月', '四月', '五月', '六月',
                '七月', '八月', '九月', '十月', '十一月', '十二月' ],
            firstDay : 1
        }
    }); 
	$('#checkTime').daterangepicker({
		timePicker: true,
		timePickerIncrement: 30,
		format: 'YYYY/MM/DD HH:mm:ss',
        locale : {
            applyLabel : '确定',
            cancelLabel : '取消',
            fromLabel : '起始时间',
            toLabel : '结束时间',
            customRangeLabel : '自定义',
            daysOfWeek : [ '日', '一', '二', '三', '四', '五', '六' ],
            monthNames : [ '一月', '二月', '三月', '四月', '五月', '六月',
                '七月', '八月', '九月', '十月', '十一月', '十二月' ],
            firstDay : 1
        }
    }); 
}
//页面加载完成后自动执行
$(function() {
	//渲染日期
	timePickInit();
	//初始化
    initOlv();
});

function parseTime1(strTime){
	if(format.test(strTime)){
		var ymdArr=strTime.split(" ")[0].split("/");//年月日
		var hmsArr=strTime.split(" ")[1].split(":");//时分秒
		return new Date(ymdArr[0],ymdArr[1]-1,ymdArr[2],hmsArr[0],hmsArr[1],hmsArr[2]).getTime();
	}
	return "";
}
//解析时间
function parseTime(str,separator,type){
	if(str){
		var arr=str.split(separator);
		var date=new Date(arr[0],arr[1]-1,arr[2]);
		if(type==1){
			date.setHours(0);
			date.setMinutes(0);
			date.setSeconds(0);
		}
		if(type==2){
			date.setHours(23);
			date.setMinutes(59);
			date.setSeconds(59);
		}
		return date.getTime();
	}
}

//以特定格式格式日期           格式：  年-月-日 时：分：秒
function formatDate(time){
	if(isNaN(time)){
		return;
	}
	var date=new Date(parseInt(time));
	var year=date.getFullYear();
	var month=date.getMonth()+1;
	month=month>9?month:'0'+month;
	var day=date.getDate();
	day=day>9?day:'0'+day;
	var hour=date.getHours();
	hour=hour>9?hour:'0'+hour;
	var minute=date.getMinutes();
	minute=minute>9?minute:'0'+minute;
	var second=date.getSeconds();
	second=second>9?second:'0'+second;
	return year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second;
}
//格式化时间二
function formateDate2(date){
	var year=date.getFullYear();
	var month=date.getMonth()+1;
	var day=date.getDate();
	return year+"/"+month+"/"+day;
}

//退款失败
function checknopass(){
	$("#editDiv").hide();
	$("#nopassDiv").show();
}
function nopasstrue(){
	$("#nopassDiv").hide();
	var sid = $("#hsid").val();
	var failReason = $("#check_memo2").val();
	var billno = $("#hbillno").val();
	$.ajax({
		type: "post",
		contentType: "application/x-www-form-urlencoded;charset=utf-8",
		url:__ctxPath + "/memDrawback/refundFalse",
		dataType:"json",
		data: {
			"sid":sid,
			"failReason":failReason,
			"billno":billno
		},
		ajaxStart: function() {$("#loading-container").attr("class","loading-container");},
		ajaxStop: function() {
			setTimeout(function() {$("#loading-container").addClass("loading-inactive");},300);
		},
		success: function(response) {
			if(response.code == "1"){
				$("#modal-body-success").html("<div class='alert alert-success fade in'><strong>退款失败成功!</strong></div>");
	     	  		$("#modal-success").attr({"style":"display:block;","aria-hidden":"false","class":"modal modal-message modal-success"});
			}else{
				$("#model-body-warning").html("<div class='alert alert-warning fade in'><i class='fa-fw fa fa-times'></i><strong>退款失败失败</strong></div>");
     	  		$("#modal-warning").attr({"style":"display:block;","aria-hidden":"false","class":"modal modal-message modal-warning"});
				
			}
			return;
		}
	});
}



//退款成功
function checkPass(){
	var sid = $("#hsid").val();
	var billno = $("#hbillno").val();
	$("#editDiv").hide();
	$.ajax({
		type: "post",
		contentType: "application/x-www-form-urlencoded;charset=utf-8",
		url:__ctxPath + "/memDrawback/refundTrue",
		dataType:"json",
		data: {
			"sid":sid,
			"billno":billno
		},
		ajaxStart: function() {$("#loading-container").attr("class","loading-container");},
		ajaxStop: function() {
			setTimeout(function() {$("#loading-container").addClass("loading-inactive");},300);
		},
		success: function(response) {
			if(response.code == "1"){
				$("#modal-body-success").html("<div class='alert alert-success fade in'><strong>退款成功!</strong></div>");
	     	  		$("#modal-success").attr({"style":"display:block;","aria-hidden":"false","class":"modal modal-message modal-success"});
			}else{
				$("#model-body-warning").html("<div class='alert alert-warning fade in'><i class='fa-fw fa fa-times'></i><strong>退款失败</strong></div>");
     	  		$("#modal-warning").attr({"style":"display:block;","aria-hidden":"false","class":"modal modal-message modal-warning"});
				
			}
			return;
		}
	});
}

//查看详细
function editMerchant(id){
	$("#hsid").val(id);
	$("#phone").html($("#applyName_"+id).html().trim());
	$.ajax({
		type: "post",
		contentType: "application/x-www-form-urlencoded;charset=utf-8",
		url:__ctxPath + "/memDrawback/getFuJiBalanceMoeny",
		dataType:"json",
		data: {
			"phone":$("#applyName_"+id).html().trim()
		},
		ajaxStart: function() {$("#loading-container").attr("class","loading-container");},
		ajaxStop: function() {
			setTimeout(function() {$("#loading-container").addClass("loading-inactive");},300);
		},
		success: function(response) {
			if(response.code == "1"){
				$("#balance").html("<span style=\"color:red;\">"+response.object.balance+"￥</span>");
				//$("#memberSid").val(response.object.memberSid);
			}else{
				$("#balance").html("<span style=\"color:red\">"+ response.desc +"</span>");
				return false;
		}
		}
	});
	
	$("#withdrowMoney").html($("#withdrowMoney_"+id).html().trim());
	$("#name").html($("#name_"+id).val());
	$("#bank").html($("#bank_"+id).html().trim());
	$("#bankCard").html($("#bankCardNo_"+id).val());
	$("#bankCard1").html($("#bankCardNo_"+id).val());
	$("#withdrowReason").html($("#withdrowReason_"+id).val());
	$("#hseqno").val($("#seqno_"+id).val());
	$("#hbillno").val($("#billno_"+id).val());
	$("#editDiv").show();
}


//查看详细
function editMerchant1(id){
	$("#phone1").html($("#applyName_"+id).html().trim());
	$("#withdrowMoney1").html($("#withdrowMoney_"+id).html().trim());
	$("#name1").html($("#name_"+id).val());
	$("#bank1").html($("#bank_"+id).html().trim());
	$("#balance1").html($("#balance_"+id).html().trim());
	$("#bankCard11").html($("#bankCardNo_"+id).val());
	$("#bankCard22").html($("#bankCardNo_"+id).val());
	$("#withdrowReason1").html($("#withdrowReason_"+id).val());
	$("#seqno1").html($("#seqno_"+id).val());
	$("#billno1").html($("#billno_"+id).val());
	$("#editDiv1").show();
}


//导出excel
function excelOrder() {
	var url=__ctxPath+"/memDrawback/getWithdrawlsList";
//	var remoteUrl="http://10.6.2.150/wfjpay/admin/order/orderExport.do?";
	var remoteUrl=__ctxPath+"/memDrawback/getWithdrowToExcel2?";
	var params = $("#olv_form").serialize();
    params = decodeURI(params);
    var downloadUrl=remoteUrl+params;
	$.post(url,params,function(data){
		if($("#olv_tab tbody tr").size()==0){
			$("#model-body-warning")
			.html(
					"<div class='alert alert-warning fade in'><strong>查询结果为空，无法导出Excel!</strong></div>");
			$("#modal-warning").attr({
				"style" : "display:block;",
				"aria-hidden" : "false",
				"class" : "modal modal-message modal-warning"
			});
			return;
		}
		
		if(data.code=="1"){
//			$("#downloadLink").attr("href",downloadUrl);
//			$("#excelDiv").show();
			window.open(downloadUrl);
		}else{
			$("#model-body-warning")
			.html(
					"<div class='alert alert-warning fade in'><strong>参数检查失败，无法正常导出Excel!</strong></div>");
			$("#modal-warning").attr({
				"style" : "display:block;",
				"aria-hidden" : "false",
				"class" : "modal modal-message modal-warning"
			});
		}
	},"json");
}

//设置表单数据
function setFormData(){
	var strTime = $("#applyTime").val();
	if(strTime!=""){
		strTime = strTime.split("-");
		$("#hidStartApplyTime").val(strTime[0].replace("/","-").replace("/","-"));
		$("#hidEndApplyTime").val(strTime[1].replace("/","-").replace("/","-"));
	}else{
		$("#hidStartApplyTime").val("");
		$("#hidEndApplyTime").val("");
	}
	
	var strTime2 = $("#checkTime").val();
	if(strTime2!=""){
		strTime = strTime.split("-");
		$("#hidStartCheckTime").val(strTime[0].replace("/","-").replace("/","-"));
		$("#hidEndCheckTime").val(strTime[1].replace("/","-").replace("/","-"));
	}else{
		$("#hidStartCheckTime").val("");
		$("#hidEndCheckTime").val("");
	}
	$("#hidsid").val($("#sid").val())
	$("#hidapplyName").val($("#applyName").val());
	$("#hidcheckStatus").val($("#checkStatus").val());
	$("#hidrefundStatus").val($("#refundStatus").val());
}

//查询数据
function olvQuery(){
	//设置表单数据
	setFormData();
	//生成表单请求参数
    var params = $("#olv_form").serialize();
    params = decodeURI(params);
    //根据参数读取数据
    olvPagination.onLoad(params);
	}
//重置
function reset(){
	$("#sid").val("");
	$("#applyTime").val("");
	$("#checkTime").val("");
	$("#appyeName").val("");
	$("#checkStatus").val("");
	$("#refundStatus").val("");
	timePickInit();
	olvQuery();
}
//初始化函数
	function initOlv() {
	//请求地址
	var url = __ctxPath+"/memDrawback/getWithdrawlsList";
	/* setFormData(); */
	
	
	//分页工具
	olvPagination = $("#olvPagination").myPagination({
       panel: {
		//启用跳页
         tipInfo_on: true,
         //跳页信息
         tipInfo: '&nbsp;&nbsp;跳{input}/{sumPage}页',
         //跳页样式
         tipInfo_css: {
           width: '25px',
           height: "20px",
           border: "2px solid #f0f0f0",
           padding: "0 0 0 5px",
           margin: "0 5px 0 5px",
           color: "#48b9ef"
         }
       },
       debug: false,
       //ajax请求
       ajax: {
         on: true,
         url: url,
         type: "post",
         //数据类型
         dataType: 'json',
        // param:$("#olv_form").serialize(),
//         //请求开始函数
//         ajaxStart: function() {
//           ZENG.msgbox.show(" 正在加载中，请稍后...", 1, 1000);
//         },
//         //请求结束函数
//         ajaxStop: function() {
//           //隐藏加载提示
//           setTimeout(function() {
//             ZENG.msgbox.hide();
//           }, 300);
//         },
         ajaxStart : function() {
				$("#loading-container").attr("class","loading-container");
			},
			ajaxStop : function() {
				//隐藏加载提示
				setTimeout(function() {
					$("#loading-container").addClass("loading-inactive");
				}, 300);
			},
         //回调
         callback: function(data) {
    		 for(var i in data.object){
    			 data.object[i].checkTimeStr=formatDate(data.object[i].checkTime);
    			 data.object[i].applyTimeStr=formatDate(data.object[i].applyTime);
    			 data.object[i].refundTimeStr=formatDate(data.object[i].refundTime);
    		 }
    		 $("#olv_tab tbody").setTemplateElement("olv-list").processTemplate(data);
         }
       }
     });
    
}

function closeMerchant(){
	$("#editDiv").hide();
}

function closeMerchant1(){
	$("#nopassDiv").hide();
}

function closeMerchant22(){
	$("#editDiv1").hide();
}

//折叠页面
function tab(data){
	if($("#"+data+"-i").attr("class")=="fa fa-minus"){
		$("#"+data+"-i").attr("class","fa fa-plus");
		$("#"+data).css({"display":"none"});
	}else if(data=='pro'){
		$("#"+data+"-i").attr("class","fa fa-minus");
		$("#"+data).css({"display":"block"});
	}else{
		$("#"+data+"-i").attr("class","fa fa-minus");
		$("#"+data).css({"display":"block"});
		$("#"+data).parent().siblings().find(".widget-body").css({"display":"none"});
		$("#"+data).parent().siblings().find(".fa-minus").attr("class","fa fa-plus");
	}
}

function successBtn(){
	$("#modal-success").attr({"style":"display:none;","aria-hidden":"true","class":"modal modal-message modal-success fade"});
	$("#pageBody").load(__ctxPath+"/jsp/mem/MemberMoneyWithdrawMange.jsp");
}
</script> 
</head>
<body>
<input type="hidden" id="ctxPath" value="${pageContext.request.contextPath}" />
<!-- Main Container -->
<div class="main-container container-fluid">
    <!-- 内容显示区域 -->
    <div class="page-container">
            <!-- Page Body -->
            <div class="page-body" id="pageBodyRight">
                <div class="row">
                    <div class="col-xs-12 col-md-12">
                        <div class="widget">
                            <div class="widget-header ">
                                <h5 class="widget-caption">余额提现退款管理</h5>
                                <div class="widget-buttons">
                                    <a href="#" data-toggle="maximize"></a>
                                    <a href="#" data-toggle="collapse" onclick="tab('pro');">
                                        <i class="fa fa-minus" id="pro-i"></i>
                                    </a>
                                    <a href="#" data-toggle="dispose"></a>
                                </div>
                            </div>
                            <div class="widget-body" id="pro">
                                <div class="table-toolbar">
                                		<ul class="topList clearfix">                           			
                                			<li class="col-md-4">
                        						<label class="titname">申请单号：</label>
			                    				<input type="text" id="sid" />
			                   				</li>
			                   				<li class="col-md-4">
			                    				<label class="titname">申请时间：</label>
			                    				<input type="text" id="applyTime" />
			                				</li>
                               				<li class="col-md-4">
	                            				<label class="titname">审核时间：</label>
	                            				<input type="text" id="checkTime"/>
                            				</li>                               				
                               				<li class="col-md-4">
                                				<label class="titname">提现手机号：</label>
                                				<input type="text" id="applyName"/>
                                			</li>
                               				<li class="col-md-4">
                               					<label class="titname">审核状态：</label>
                               					<select  id="checkStatus">
												<option value="">请选择</option>
												<option value="1">待审核</option>
												<option value="2">审核通过</option>
												<option value="3">审核不通过</option>
												</select>
                               				</li>
                                			
                               				<li class="col-md-4">
		                           				<label class="titname">退款状态：</label>
		                           				<select  id="refundStatus">
												<option value="">请选择</option>
												<option value="1">待退款</option>
												<option value="2">退款成功</option>
												<option value="3">退款失败</option>
												</select>
                               				</li>
                            				<li class="col-md-4">
                            					<a class="btn btn-default shiny" onclick="olvQuery();">查询</a>&nbsp;&nbsp;
                            					<a class="btn btn-default shiny" onclick="reset();">重置</a>&nbsp;&nbsp;
												<a class="btn btn-yellow" onclick="excelOrder();">导出</a>
											</li>
                                		</ul>
                                	<!--隐藏参数-->
                           			<form id="olv_form" action="">
										<input type="hidden" id="hidsid" name="hidsid"/>
										<input type="hidden" id="hidStartApplyTime" name="hidStartApplyTime"/>
										<input type="hidden" id="hidEndApplyTime" name="hidEndApplyTime"/>
										<input type="hidden" id="hidStartCheckTime" name="hidStartCheckTime"/>
										<input type="hidden" id="hidEndCheckTime" name="hidEndCheckTime"/>
										<input type="hidden" id="hidapplyName" name="hidapplyName"/>
										<input type="hidden" id="hidcheckStatus" name="hidcheckStatus"/>
										<input type="hidden" id="hidrefundStatus" name="hidrefundStatus"/>
                                  	</form>
                                <!--数据列表显示区域-->
                            	<div style="width:100%; min-height:400px; overflow-Y: hidden;">
                                <table class="table-striped table-hover table-bordered" id="olv_tab" style="width: 200%;background-color: #fff;margin-bottom: 0;">
                                    <thead>
                                        <tr role="row" style='height:35px;'>
                                            <th width="1%" style="text-align: center;">操作</th>
                                            <th width="2%" style="text-align: center;">申请单号</th>
                                            <th width="1%" style="text-align: center;">提现手机号</th>
                                            <th width="1%" style="text-align: center;">申请人</th>
                                            <th width="1%" style="text-align: center;">申请时间</th>
                                            <th width="2%" style="text-align: center;">提现原因</th>
                                            <th width="2%" style="text-align: center;">提现银行</th>
                                            <th width="2%" style="text-align: center;">开户名</th>
                                            <th width="2%" style="text-align: center;">卡号</th>
                                            <th width="1%" style="text-align: center;" >提现金额</th>
                                            <th width="1%" style="text-align: center;">用户余额</th>
                                            <th width="2%" style="text-align: center;">取消原因</th>
                                            <th width="2%" style="text-align: center;">审核状态</th>
                                            <th width="2%" style="text-align: center;">审核备注</th>
                                             <th width="2%" style="text-align: center;">审核人</th>
                                              <th width="2%" style="text-align: center;">审核时间</th>
                                            <th width="2%" style="text-align: center;">退款状态</th>
                                            <th width="2%" style="text-align: center;">失败原因</th>
                                            <th width="2%" style="text-align: center;">退款人</th>
                                            <th width="2%" style="text-align: center;">退款时间</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                                </div>
                                <!--分页工具-->
                                <div id="olvPagination"></div>
                            </div>
                            <!--模板数据-->
							<!-- Templates -->
							<!--默认隐藏-->
							<p style="display:none">
								<textarea id="olv-list" rows="0" cols="0">
								{#template MAIN}
									{#foreach $T.object as Result}
										<tr class="gradeX" id="gradeX{$T.Result.sid}" ondblclick="trClick('{$T.Result.orderTradeNo}',this)" style="height:35px;">
											
										<td align="center">
												<input type="hidden"  id="name_{$T.Result.sid}"  value="{$T.Result.name}">
												<input type="hidden"  id="bankCardNo_{$T.Result.sid}"  value="{$T.Result.bankCardNo}">
												<input type="hidden"  id="withdrowReason_{$T.Result.sid}"  value="{$T.Result.withdrowReason}">
												<input type="hidden"  id="seqno_{$T.Result.sid}"  value="{$T.Result.seqno}">
												<input type="hidden"  id="billno_{$T.Result.sid}"  value="{$T.Result.billno}">
												{#if $T.Result.refundStatus == '1'}
												 <a href="javascript:editMerchant({$T.Result.sid});">
														    <span class="btn btn-blue"><i class="fa fa-edit"></i>查看</span>
														</a>
				                   				{#/if}
											  
											</td>
											<td align="center" id="sid_{$T.Result.sid}" value="{$T.Result.sid}">
												<a onclick="javascript:editMerchant1({$T.Result.sid});">{#if $T.Result.sid != '[object Object]'}{$T.Result.seqno}
				                   				{#/if}</a>
											</td>
											<td align="center" id="mobile_{$T.Result.sid}" value="{$T.Result.mobile}">
												{#if $T.Result.mobile!= '[object Object]'}{$T.Result.mobile}
				                   				{#/if}
											</td>
											<td align="center" id="applyName_{$T.Result.sid}" value="{$T.Result.applyName}">
												{#if $T.Result.applyName!= '[object Object]'}{$T.Result.applyName}
												{#elseif $T.Result.applyCustomer != '[object Object]'}-{$T.Result.applyCustomer}
				                   				{#/if}
											</td>
											<td align="center" id="applyTimeStr_{$T.Result.sid}" value="{$T.Result.applyTimeStr}">
												{#if $T.Result.applyTimeStr!= '[object Object]'}{$T.Result.applyTimeStr}
				                   				{#/if}
											</td>
											<td align="center" id="withdrowReason_{$T.Result.sid}" value="{$T.Result.withdrowReason}">
												{#if $T.Result.withdrowReason != '[object Object]'}{$T.Result.withdrowReason}
				                   				{#/if}
											</td>
											<td align="center" id="bank_{$T.Result.sid}" value="{$T.Result.bank}">
												{#if $T.Result.bank != '[object Object]'}{$T.Result.bank}
				                   				{#/if}
			                   				</td>
			                   				<td align="center" id="name_{$T.Result.sid}" value="{$T.Result.name}">
												{#if $T.Result.name != '[object Object]'}{$T.Result.name}
				                   				{#/if}
			                   				</td>
			                   				<td align="center" id="bankCardNo_{$T.Result.sid}" value="{$T.Result.bankCardNo}">
												{#if $T.Result.bankCardNo != '[object Object]'}{$T.Result.bankCardNo}
				                   				{#/if}
			                   				</td>
											<td align="center" id="withdrowMoney_{$T.Result.sid}" value="{$T.Result.withdrowMoney}">
												{#if $T.Result.withdrowMoney != '[object Object]'}{$T.Result.withdrowMoney}
				                   				{#/if}
											</td>
											<td align="center" id="balance_{$T.Result.sid}" value="{$T.Result.balance}">
												{#if $T.Result.balance!= '[object Object]'}{$T.Result.balance}
				                   				{#/if}
											</td>
											<td align="center" id="cancelReason_{$T.Result.sid}" value="{$T.Result.cancelReason}">
												{#if $T.Result.cancelReason != '[object Object]'}{$T.Result.cancelReason}
				                   				{#/if}
											</td>
											<td align="center" id="checkStatus_{$T.Result.sid}" value="{$T.Result.checkStatus}">
												{#if $T.Result.checkStatus == '1'}待审核
												{#elseif $T.Result.checkStatus == '2'}审核通过
												{#elseif $T.Result.checkStatus == '3'}审核不通过
												{#elseif $T.Result.checkStatus == '4'}取消
				                   				{#/if}
											</td>
											<td align="center" id="checkMemo_{$T.Result.sid}" value="{$T.Result.checkMemo}">
												{#if $T.Result.checkMemo != '[object Object]'}{$T.Result.checkMemo}
				                   				{#/if}
				                   				
											</td>
											<td align="center" id="checkName_{$T.Result.sid}" value="{$T.Result.checkName}">
												{#if $T.Result.checkName != '[object Object]'}{$T.Result.checkName}
				                   				{#/if}
											</td>
											<td align="center" id="checkTime_{$T.Result.sid}" value="{$T.Result.checkTime}">
												{#if $T.Result.checkTime != '[object Object]'}{$T.Result.checkTime}
				                   				{#/if}
											</td>
											<td align="center" id="refundStatus_{$T.Result.sid}" value="{$T.Result.refundStatus}">
												{#if $T.Result.refundStatus == '1'}待退款
												{#elseif $T.Result.refundStatus == '2'}退款成功
												{#elseif $T.Result.refundStatus == '3'}退款失败
				                   				{#/if}
											</td>
											<td align="center" id="failReason_{$T.Result.sid}" value="{$T.Result.failReason}">
												{#if $T.Result.failReason != '[object Object]'}{$T.Result.failReason}
				                   				{#/if}
											</td>
											<td align="center" id="refundName_{$T.Result.sid}" value="{$T.Result.refundName}">
												{#if $T.Result.refundName != '[object Object]'}{$T.Result.refundName}
				                   				{#/if}
											</td>
											<td align="center" id="refundTimeStr_{$T.Result.sid}" value="{$T.Result.refundTimeStr}">
												{#if $T.Result.refundTimeStr != '[object Object]'}{$T.Result.refundTimeStr}
				                   				{#/if}
											</td>
							       		</tr>
									{#/for}
							    {#/template MAIN}	
								</textarea>
							</p>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /Page Body -->
        </div>
        <!-- /Page Content -->
    </div>
    <!-- /Page Container -->
    <!-- Main Container -->
</div>   
<div class="modal modal-darkorange" style="background: 0.5, 0.5, 0.5;" 
		id="editDiv">
		<div class="modal-dialog"
			style="width: 800px; height: auto; margin: 4% auto;">
			<div class="modal-content">
				<div class="modal-header">
					<button aria-hidden="true" data-dismiss="modal" class="close"
						type="button" onclick="closeMerchant();">×</button>
					<h4 class="modal-title" id="divTitle">查看提现申请</h4>
				</div>
				<div class="page-body" id="pageBodyRight">
					<div class="row">
						<form method="post" class="form-horizontal" id="editForm">
							<div class="col-xs-12 col-md-12">
								<input type="hidden" name="hsid" id="hsid" value=""/>
								<input type="hidden" name="hseqno" id="hseqno" value=""/>
								<input type="hidden" name="hbillno" id="hbillno" value=""/>
									<div class="col-md-12" id="" style="padding: 10px 100px;">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">登录帐号：</label>
									<div class="col-md-6" id="phone">
										
									</div>
									<br>&nbsp;
									</div>
									
								<div class="col-md-12" id="" style="padding: 10px 100px;">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">用户余额：</label>
										<div class="col-md-6" id="balance">
										
									</div>
									<br>&nbsp;
								</div>
								
								<div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">提现金额：</label>
									<div class="col-md-6" id="withdrowMoney">
								
									</div>
									<br>&nbsp;
								   </div>
								   
								  <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">开户名：</label>
									<div class="col-md-6" id="name">
										
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">开户银行：</label>
									<div class="col-md-6" id="bank">
										
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">银行卡号：</label>
									<div class="col-md-6" id="bankCard">
										
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">确认卡号：</label>
									<div class="col-md-6" id="bankCard1">
										
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">申请理由：</label>
									<div class="col-md-6" id="withdrowReason">
										
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">退款介质：</label>
									<div class="col-md-6" id="withdrowMedium">
										支付宝
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">退款类型：</label>
									<div class="col-md-6" id="withdrowType">
										支付宝批量付
									</div>
									<br>&nbsp;
								   </div>
								   
								    <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">退款结果：</label>
									<div class="col-md-6" id="withdrowResult">
										
									</div>
									<br>&nbsp;
								   </div>
								   
								    <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">退款失败原因：</label>
									<div class="col-md-6" id="whyfalse">
										
									</div>
									<br>&nbsp;
								   </div>
							</div>
							<br>&nbsp;
							<div class="form-group">
								<div class="col-lg-offset-4 col-lg-7">
									<button onclick="checkPass();" style="width: 90px;" id="pass" type="button">退款完成</button>	
									&emsp;&emsp;&emsp;&emsp;
									<button onclick="checknopass();" style="width: 90px;" id="nopass" type="button">退款失败</button>						
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<div class="modal modal-darkorange" style="background: 0.5, 0.5, 0.5;" 
		id="editDiv1">
		<div class="modal-dialog"
			style="width: 800px; height: auto; margin: 4% auto;">
			<div class="modal-content">
				<div class="modal-header">
					<button aria-hidden="true" data-dismiss="modal" class="close"
						type="button" onclick="closeMerchant22();">×</button>
					<h4 class="modal-title" id="divTitle">查看提现申请</h4>
				</div>
				<div class="page-body" id="pageBodyRight">
					<div class="row">
						<form method="post" class="form-horizontal" id="editForm">
							<div class="col-xs-12 col-md-12">
								<input type="hidden" name="hsid" id="hsid" value=""/>
									<div class="col-md-12" id="" style="padding: 10px 100px;">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">登录帐号：</label>
									<div class="col-md-6" id="phone1">
										
									</div>
									<br>&nbsp;
									</div>
								<div class="col-md-12" id="" style="padding: 10px 100px;">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">申请单号：</label>
										<div class="col-md-6" id="seqno1">
										
									</div>
									<br>&nbsp;
								</div>
								
								<div class="col-md-12" id="" style="padding: 10px 100px;">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">流水号：</label>
										<div class="col-md-6" id="billno1">
										
									</div>
									<br>&nbsp;
								</div>
									
								<div class="col-md-12" id="" style="padding: 10px 100px;">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">用户余额：</label>
										<div class="col-md-6" id="balance1">
										
									</div>
									<br>&nbsp;
								</div>
								
								<div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">提现金额：</label>
									<div class="col-md-6" id="withdrowMoney1">
									</div>
									<br>&nbsp;
								   </div>
								   
								  <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">开户名：</label>
									<div class="col-md-6" id="name1">
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">开户银行：</label>
									<div class="col-md-6" id="bank1">
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">银行卡号：</label>
									<div class="col-md-6" id="bankCard11">
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">确认卡号：</label>
									<div class="col-md-6" id="bankCard22">
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">申请理由：</label>
									<div class="col-md-6" id="withdrowReason1">
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">退款介质：</label>
									<div class="col-md-6" id="withdrowMedium1">
										支付宝
									</div>
									<br>&nbsp;
								   </div>
								   
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">退款类型：</label>
									<div class="col-md-6" id="withdrowType1">
										支付宝批量付
									</div>
									<br>&nbsp;
								   </div>
							</div>
						</form>
					</div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<div class="modal modal-darkorange" style="background: 0.5, 0.5, 0.5;" 
		id="nopassDiv">
		<div class="modal-dialog"
			style="width: 600px; height: auto; margin: 4% auto;">
			<div class="modal-content">
			<div class="modal-header">
					<button aria-hidden="true" data-dismiss="modal" class="close"
						type="button" onclick="closeMerchant1();">×</button>
					<h4 class="modal-title" id="divTitle">退款失败</h4>
				</div>
				<div class="page-body" id="pageBodyRight">
					<div class="row">
						<form method="post" class="form-horizontal" id="editForm">
								   <div class="col-md-12" id="" style="padding: 10px 100px;" id="old_input">
									<label class="col-md-5 control-label"
										style="line-height: 20px; text-align: right;">退款失败理由：</label>
									<div class="col-md-6">
										<textarea class="withdrowReason" cols="30%;"
											id=check_memo2></textarea>
									</div>
									<br>&nbsp;
								   </div>
							<br>&nbsp;
							<div class="form-group">
								<div class="col-lg-offset-4 col-lg-7">
									<button  style="width: 90px;" id="edit"
										type="button" onclick="nopasstrue();">确认</button>
									&emsp; 
									
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
<script>

</script> 
</body>
</html>