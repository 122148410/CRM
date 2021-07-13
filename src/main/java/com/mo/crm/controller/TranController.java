package com.mo.crm.controller;


import com.mo.crm.domain.Tran;
import com.mo.crm.domain.TranHistory;
import com.mo.crm.domain.User;
import com.mo.crm.service.CustomerService;
import com.mo.crm.service.TranService;
import com.mo.crm.service.UserService;
import com.mo.crm.utils.DateTimeUtil;
import com.mo.crm.utils.PrintJson;
import com.mo.crm.utils.UUIDUtil;
import com.mo.crm.vo.PaginationVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/transaction")
public class TranController {

    @Autowired
    private TranService tranService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private UserService userService;

    @ResponseBody
    @RequestMapping("/getHistoryListByTranId.do")
    public List<TranHistory> getHistoryListByTranId(HttpServletRequest request){
        System.out.println("根据交易id取得相应的历史列表");

        String tranId = request.getParameter("tranId");
        List<TranHistory> thList= tranService.getHistoryListByTranId(tranId);
        //阶段和可能性之间的对应关系
        Map<String,String> pMap = (Map<String, String>) request.getServletContext().getAttribute("pMap");

        //将交易历史列表遍历
        for(TranHistory th : thList){

            //根据每条交易历史，取出每一个阶段
            String stage = th.getStage();
            String possibility = pMap.get(stage);
            th.setPossibility(possibility);

        }
        return thList;
    }



    //@ResponseBody
    @RequestMapping("/getCustomerName.do")
    public void getCustomerName(HttpServletRequest request ,HttpServletResponse response){
        String name = request.getParameter("name");
        List<String> sList = customerService.getCustomerName(name);

        PrintJson.printJsonObj(response,sList);
    }



    @ResponseBody
    @RequestMapping("/save.do")
    public boolean save(Tran t, HttpServletResponse response, HttpSession session,HttpServletRequest request) throws IOException {

        System.out.println("执行添加交易的操作");

//        String owner = request.getParameter("owner");
//        String money = request.getParameter("money");
//        String name = request.getParameter("name");
//        String expectedDate = request.getParameter("expectedDate");
//        String stage = request.getParameter("stage");
//        String type = request.getParameter("type");
//        String source = request.getParameter("source");
//        String activityId = request.getParameter("activityId");
//        String contactsId = request.getParameter("contactsId");
//        String description = request.getParameter("description");
//        String contactSummary = request.getParameter("contactSummary");
//        String nextContactTime = request.getParameter("nextContactTime");
        String customerName = request.getParameter("customerName"); //此处我们暂时只有客户名称，还没有id
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)session.getAttribute("user")).getName();

        /*Tran t = new Tran();
        t.setOwner(owner);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setType(type);
        t.setSource(source);
        t.setActivityId(activityId);
        t.setContactsId(contactsId);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setNextContactTime(nextContactTime);*/
        t.setCreateTime(createTime);
        t.setCreateBy(createBy);
        t.setId(id);

        boolean flag = tranService.save(t,customerName);

        if(flag){

            //如果添加交易成功，跳转到列表页
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");

        }
        return flag;

    }


    @ResponseBody
    @RequestMapping("/detail.do")
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, ServletException {
        System.out.println("跳转到详细信息页");
        String id = request.getParameter("id");
        Tran t = tranService.detail(id);
        //处理可能性
        /*

            阶段 t
            阶段和可能性之间的对应关系 pMap

         */
        String stage = t.getStage();
        Map<String,String> pMap = (Map<String,String>)request.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(stage);

        t.setPossibility(possibility);

        request.setAttribute("t", t);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request, response);

    }




    @ResponseBody
    @RequestMapping("/add.do")
    public void add(HttpServletRequest request,HttpServletResponse response,HttpSession session) throws ServletException, IOException {
        System.out.println("进入到跳转到交易添加页的操作");

        List<User> uList = userService.getUserList();

        request.setAttribute("uList", uList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request, response);
    }




    @ResponseBody
    @RequestMapping("/changeStage.do")
    public Map<String,Object> changeStage(Tran t, HttpServletRequest request,HttpSession session){
        System.out.println("执行改变阶段的操作");

        //String stage = request.getParameter("stage");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        //t.setStage(stage);
        t.setEditBy(editBy);
        t.setEditTime(editTime);


        boolean flag = tranService.changeStage(t);

        Map<String,String> pMap = (Map<String,String>)request.getServletContext().getAttribute("pMap");
        t.setPossibility(pMap.get(t.getStage()));

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("t", t);
        return map;
    }


    @ResponseBody
    @RequestMapping("/getCharts.do")
    public Map<String,Object> getCharts(){
        System.out.println("取得交易阶段数量统计图表的数据");

        /*

            业务层为我们返回
                total
                dataList

                通过map打包以上两项进行返回


         */
        Map<String,Object> map = tranService.getCharts();

      return map;


    }

    @ResponseBody
    @RequestMapping("/pageTransactionList.do")
    public PaginationVO<Tran> pageTransactionList(HttpServletRequest request,Tran t){
        System.out.println("查询交易Transaction（结合条件查询+分页查询）");

        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);
        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizeStr);
        //需要跳过的页面数据
        int skipCount = (pageNo-1)*pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("t",t);
        PaginationVO<Tran> vo = tranService.pageTransactionList(map);
        return vo;
    }

    @ResponseBody
    @RequestMapping("/transactionQuery.do")
    public List<Tran> transactionQuery(Tran t){
        System.out.println("查询交易Transaction（条件查询）");

        List<Tran> tranList = tranService.transactionQuery(t);

        return tranList;

    }




    @ResponseBody
    @RequestMapping("/edit.do")
    public void searchTranById(HttpServletResponse response , HttpServletRequest request,String id) throws ServletException, IOException {
        System.out.println("交易修改111=-=-=-=-=-=-edit.do");

        Tran tran  = tranService.searchTran(id);
        List<User> uList = userService.getUserList();
        Tran t  = tranService.searchTranId(id);

        Map<String,String> pMap = (Map<String,String>)request.getServletContext().getAttribute("pMap");
        tran.setPossibility(pMap.get(tran.getStage()));

        request.setAttribute("tran",tran);
        request.setAttribute("uList",uList);
        request.setAttribute("t",t);
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request,response);
    }


    @ResponseBody
    @RequestMapping("/updateTranById.do")
    public Map<String, Object> updateTranById(HttpServletRequest request, Tran t){
        System.out.println("交易修改2222=-=-=-=-=-=-updateTranById.do");

       boolean flag = tranService.updateTranById(t);

        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        //t.setStage(stage);
        t.setEditBy(editBy);
        t.setEditTime(editTime);


        Map<String,String> pMap = (Map<String,String>)request.getServletContext().getAttribute("pMap");
        t.setPossibility(pMap.get(t.getStage()));

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success", flag);
        map.put("t", t);
        return map;

    }


    @ResponseBody
    @RequestMapping("/transactionUpdate.do")
    public  boolean transactionUpdate(String id) {
        System.out.println("交易修改111=-=-=-=-=-=-transactionUpdate.do");

        /*Map<String,Object>*/
       // Tran tran  = tranService.searchTran(id);
       // List<User> uList = userService.getUserList();
       // Tran t  = tranService.searchTranId(id);

       // Map<String,Object> map = new HashMap<>();
       // map.put("tran",tran);
       // map.put("uList",uList);
      //  map.put("t",t);

      /*  Map<String,String> pMap = (Map<String,String>)request.getServletContext().getAttribute("pMap");
        tran.setPossibility(pMap.get(tran.getStage()));
*/
       /* request.setAttribute("tran",tran);
        request.setAttribute("uList",uList);
        request.setAttribute("t",t);*/


        boolean flag = true;
        return flag;
    }




    @ResponseBody
    @RequestMapping("/delete.do")
    public boolean delete(@RequestParam("id") String[] ids){
        System.out.println("删除交易delete=-=-=-=-=-=-delete.do");

       boolean flag = tranService.delete(ids);
       return flag;

    }




}
