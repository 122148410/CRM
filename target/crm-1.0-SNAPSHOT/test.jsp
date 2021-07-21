<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
            request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <title>Title</title>
    <base href="<%=basePath%>">
</head>
<body>


<style>
    .form-control-feedback-my {
        position: absolute;
        top: 0;
        right: 0;
        z-index: 2;
        display: block;
        width: 34px;
        height: 34px;
        line-height: 34px;
        text-align: center;
        pointer-events: auto;
        cursor: pointer;
    }
</style>


$(".time").datetimepicker({
minView: "month",
language:  'zh-CN',
format: 'yyyy-mm-dd',
autoclose: true,
todayBtn: true,
pickerPosition: "bottom-left"
});


            $.ajax({
            url : "",
            data : {

            },
            type : "",
            dataType : "json",
            success : function (data) {

            }

            })




            // 修改时间: 当前系统时间
            String editTime = DateTimeUtil.getSysTime();
            // 修改人: 当前登录用户
            String editBy = ((User) session.getAttribute("user")).getName();


            String createTime = DateTimeUtil.getSysTime();
            String createBy = ((User)session.getAttribute("user")).getName();

            $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "bottom-left"
            });



            /*
            *
            * $("#XXXPage").bs_pagination('getOption', 'currentPage'):
            * 		操作后停留在当前页
            *
            * $("#XXXPage").bs_pagination('getOption', 'rowsPerPage')
            * 		操作后维持已经设置好的每页展现的记录数
            *
            * 这两个参数不需要我们进行任何的修改操作
            * 	直接使用即可
            *
            *     XXXList($("#XXXPage").bs_pagination('getOption', 'currentPage')
            *     ,$("#XXXPage").bs_pagination('getOption', 'rowsPerPage'));
            * */





        <%--自动补全--%>
            <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
            $("#需要绑定的input").typeahead({
            source: function (query, process) {
            $.get(
            "workbench/transaction/getCustomerName.do",
            { "name" : query },
            function (data) {
            //alert(data);

            /*

            data
            [{客户名称1},{2},{3}]

            */

            process(data);
            },
            "json"
            );
            },
            //等待1.5秒
            delay: 1500
            });


          //第二种自动补全
            $("#create-customerName").typeahead({
            //最多显示的下拉列表内容
            items:8,
            //将浏览器默认提示关闭
            autocomplete:"off",
            source: function (query, process) {
            $.post(
            "workbench/transaction/getCustomerName.do",
            { "name" : query },
            function (data) {
            alert("返回数据"+data);
            process(data);
            },
            "json"
            );
            },
            delay: 1500
            });



</body>
</html>
