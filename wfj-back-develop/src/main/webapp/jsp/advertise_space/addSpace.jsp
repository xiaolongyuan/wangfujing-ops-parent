<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="modal modal-darkorange" id="addSpaceDIV">
					<div class="modal-dialog" style="width: 400px; margin: 100px auto;">
						<div class="modal-content">
							<div class="modal-header">
								<button aria-hidden="true" data-dismiss="modal" class="close"
									type="button" onclick="closeDiv();">×</button>
								<h4 class="modal-title">添加广告版位</h4>
							</div>
							<div class="modal-body">
									<div class="row" style="padding: 10px;">
										<div class="col-md-12">
											<form id="addSpaceForm" method="post" class="form-horizontal" >
									<input type="hidden" id="site_id_add" name="_site_id_param" >
									<div class="form-group">
										<label class="col-lg-3 control-label"><span style="color:red;">*</span>名称</label>
										<div class="col-lg-6">
										    <div class="input-icon " >
										    <i class="fa"></i>										
											<input type="text" style="width:84%"  class="form-control clear_input" id="name" name="name" />											
											</div>										
										</div>
									</div>
									<div class="form-group">
										<label class="col-lg-3 control-label">位置</label>
											<select style="width:40%;margin-left:15px;" class="form-control position" id="add_position" name="position">
												<option value="">--无--</option>
											</select>
									</div>
									<div class="form-group">
										<label class="col-lg-3 control-label">描述</label>
										<div class="col-lg-2">
											<textarea class="clear_input" style="width: 160px;height: 50px;" id="desc" name="desc" ></textarea>
										</div>
        							</div>
        							<div class="form-group" id="add_space_enabled">
										<label class="col-lg-3 control-label">启用</label>
										<div class="col-lg-6">
											<div class="radio">
												<label>
													<input class="basic" type="radio" checked="checked" name="enabled" value="true">
													<span class="text">是</span>
												</label>
												<label>
													<input class="basic" type="radio" name="enabled" value="false">
													<span class="text">否</span>
												</label>
											</div>
											<div class="radio" style="display: none;">
												<label>
													<input class="inverted" type="radio" name="enabled">
													<span class="text"></span>
												</label>
											</div>
										</div>
        							</div>
         							<div class="form-group">
										<div class="col-lg-offset-4 col-lg-6">
											<input class="btn btn-success" style="width: 35%;" id="save" type="button" value="保存" />&emsp;&emsp;
											<input class="btn btn-danger" style="width: 35%;" id="close" onclick="closeDiv();" type="button" value="取消"/>
										</div>
									</div>
								</form>
										</div>
									</div>
								</div>
							</div>
						<!-- /.modal-content -->
					</div>
					<!-- /.modal-dialog -->
				</div>