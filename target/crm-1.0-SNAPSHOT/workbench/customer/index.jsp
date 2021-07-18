<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
			request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>



<script type="text/javascript">

	$(function(){

        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "top-left"
        });
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		pageCustomerList(1,5);



		$("#saveBtn").click(function () {
            $.ajax({
                url : "workbench/customer/save.do",
                data : {
                    "owner":$.trim($("#create-owner").val()),
                    "name":$.trim($("#create-name").val()),
                    "website":$.trim($("#create-website").val()),
                    "phone":$.trim($("#create-phone").val()),
                    "contactSummary":$.trim($("#create-contactSummary").val()),
                    "nextContactTime":$.trim($("#create-nextContactTime").val()),
                    "description":$.trim($("#create-description").val()),
                    "address":$.trim($("#create-address").val()),
                },
                type : "post",
                dataType : "json",
                success : function (data) {

                    if (data) {

						pageCustomerList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

						//重置表单
						$("#customerAddForm")[0].reset();

                       $("#createCustomerModal").modal("hide");

                        alert("创建客户成功");
                    } else {
                        alert("创建客户失败");
                    }

                }

            })
        })



		$("#createBtn").click(function () {

            $.ajax({
                url : "workbench/customer/getUserList.do",
                type : "get",
                dataType : "json",
                success : function (data) {

                    var html = "<option></option>";

                    $.each(data,function (i,n) {
                       html += "<option value='"+n.id+"'>"+n.name+"</option>";
                    })
                    $("#create-owner").html(html);

                    var id = "${user.id}";
                 //   alert(id);

                    $("#create-owner").val(id);

                    $("#createCustomerModal").modal("show");


                }

            })

        })




        $("#editBtn").click(function () {

            var $xz = $("input[name=xz]:checked");
            var id = $xz.val();
           // alert($xz)
           // alert(id)
            if ($xz.length == 0) {
                alert("请选择修改的客户记录");
            } else if ($xz.length > 1) {
                alert("只能选择修改一条客户记录");
            } else {
                $.ajax({
                    url : "workbench/customer/getUserListAndCustomer.do",
                    data : {
                      "id":id
                    },
                    type : "get",
                    dataType : "json",
                    success : function (data) {

                        var html = "<option></option>";
                        $.each(data.uList,function (i,n) {
                            html += "<option value='"+n.id+"'>"+n.name+"</option>";
                        })
                        $("#edit-owner").html(html);

                        //处理单条Customer
						$("#edit-id").val(data.customer.id);
                        $("#edit-name").val(data.customer.name);
                        $("#edit-owner").val(data.customer.owner);
                        $("#edit-website").val(data.customer.website);
                        $("#edit-phone").val(data.customer.phone);
                        $("#edit-nextContactTime").val(data.customer.nextContactTime);
                        $("#edit-contactSummary").val(data.customer.contactSummary);
                        $("#edit-description").val(data.customer.description);
                        $("#edit-address").val(data.customer.address);

                        $("#editCustomerModal").modal("show");

                    }

                })
            }

        })





		$("#updateBtn").click(function () {
			$.ajax({
				url : "workbench/customer/update.do",
				data : {
					"id":$.trim($("#edit-id").val()),
					"owner":$.trim($("#edit-owner").val()),
					"name":$.trim($("#edit-name").val()),
					"website":$.trim($("#edit-website").val()),
					"phone":$.trim($("#edit-phone").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"description":$.trim($("#edit-description").val()),
					"address":$.trim($("#edit-address").val()),
				},
				type : "post",
				dataType : "json",
				success : function (data) {

					if (data) {
						/*
						*
						* $("#customerPage").bs_pagination('getOption', 'currentPage'):
						* 		操作后停留在当前页
						*
						* $("#customerPage").bs_pagination('getOption', 'rowsPerPage')
						* 		操作后维持已经设置好的每页展现的记录数
						*
						* 这两个参数不需要我们进行任何的修改操作
						* 	直接使用即可
						*
						* */
						pageCustomerList($("#customerPage").bs_pagination('getOption', 'currentPage')
						,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

						$("#editCustomerModal").modal("hide");
						alert("修改成功");

					} else {
						alert("修改失败");
					}

				}

			})

		})



		$("#deleteBtn").click(function () {

			var $xz = $("input[name=xz]:checked");

			if ($xz.length == 0) {
				alert("请选择删除的记录");
			} else {
				if (confirm("确定删除吗?")) {
					var param = "";
					for (var i = 0; i < $xz.length; i++) {
						param += "id="+$($xz[i]).val();
						if (i<$xz.length-1) {
							param += "&";
						}
					}

					//alert(param);

					$.ajax({
						url : "workbench/customer/delete.do",
						data :param,
						type : "post",
						dataType : "json",
						success : function (data) {

							if (data) {
								//pageCustomerList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
								pageCustomerList(1,3);
								alert("删除成功");
							} else {
								alert("删除失败");
							}
						}

					})


				}
			}

		})



		$("#qx").click(function () {
           $("input[name=xz]").prop("checked",this.checked);
		})

		//根据条件搜索
		$("#searchCustomer").click(function () {

			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-phone").val($.trim($("#search-phone").val()));
			$("#hidden-website").val($.trim($("#search-website").val()));

			pageCustomerList(1,5);

		})




	});





	function pageCustomerList(pageNo,pageSize) {

		$("#seacrch-name").val($.trim($("#hidden-name").val()));
		$("#seacrch-owner").val($.trim($("#hidden-owner").val()));
		$("#seacrch-phone").val($.trim($("#hidden-phone").val()));
		$("#seacrch-website").val($.trim($("#hidden-website").val()));

		$.ajax({
			url : "workbench/customer/pageCustomerList.do",
			data : {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"phone":$.trim($("#search-phone").val()),
				"website":$.trim($("#search-website").val()),
			},
			type : "get",
			dataType : "json",
			success : function (data) {

				var html = "";
				$.each(data.dataList,function (i,n) {
						html += '<tr>';
						html += '<td><input type="checkbox" name="xz" value="'+n.id+'" /></td>';
						html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
						html += '<td>'+n.owner+'</td>';
						html += '<td>'+n.phone+'</td>';
						html += '<td>'+n.website+'</td>';
						html += '</tr>';
				})
				$("#customerBody").html(html);

				//计算总页数
				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;

				//数据处理完毕后，结合分页查询，对前端展现分页信息
				$("#customerPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 25, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks:5, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					//该回调函数时在，点击分页组件的时候触发的
					onChangePage : function(event, data){
						pageCustomerList(data.currentPage , data.rowsPerPage);
					}
				});

			}

		})


	}
	
</script>
</head>
<body>

    <input type="hidden" id="hidden-owner">
    <input type="hidden" id="hidden-name">
    <input type="hidden" id="hidden-website">
    <input type="hidden" id="hidden-phone">



	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="customerAddForm" role="form">

						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" readonly placeholder="点击选择下次联系时间" class="form-control time" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveBtn" class="btn btn-primary" data-dismiss="modal">保存123</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" >
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" >
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" readonly placeholder="点击选择下次联系时间" class="form-control time" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="updateBtn" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称1</div>
				      <input class="form-control" id="search-name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="search-owner" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" id="search-phone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" id="search-website" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="searchCustomer" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" id="createBtn" class="btn btn-primary" data-toggle="modal" ><span class="glyphicon glyphicon-plus"></span> 创建22</button>
				  <button type="button" id="editBtn" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/customer/detail.jsp';">动力节点</a></td>
							<td>zhangsan</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/customer/detail.jsp';">动力节点</a></td>
                            <td>zhangsan</td>
                            <td>010-84846003</td>
                            <td>http://www.bjpowernode.com</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div  style="height: 50px; position: relative;top: 30px;">
				<div id="customerPage"></div>
				<%--<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>--%>
			<%--	<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>--%>
				<%--<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>