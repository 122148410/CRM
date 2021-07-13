package com.mo.crm.controller;

import com.mo.crm.domain.*;
import com.mo.crm.service.ContactsService;
import com.mo.crm.service.CustomerService;
import com.mo.crm.service.TranService;
import com.mo.crm.service.UserService;
import com.mo.crm.utils.DateTimeUtil;
import com.mo.crm.utils.UUIDUtil;
import com.mo.crm.vo.PaginationVO;
import javafx.application.Application;
import org.apache.ibatis.transaction.Transaction;
import org.omg.CORBA.PRIVATE_MEMBER;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private UserService userService;

    @Autowired
    private TranService tranService;

    @Autowired
    private ContactsService contactsService;




    @ResponseBody
    @RequestMapping("/pageCustomerList.do")
    public PaginationVO<Customer> pageCustomerList(HttpServletRequest request,Customer c){
        System.out.println("进入客户铺数据操作pageCustomerList.do");

       String pageNoStr = request.getParameter("pageNo");
       int pageNo = Integer.valueOf(pageNoStr);

       String pageSizeStr = request.getParameter("pageSize");
       int pageSize = Integer.valueOf(pageSizeStr);

       int skipCount = (pageNo-1)*pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("c",c);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVO<Customer> vo = customerService.pageCustomerList(map);
        return vo;
    }

    @ResponseBody
    @RequestMapping("/searchCustomer.do")
    public List<Customer> searchCustomer(Customer c) {
        System.out.println("进入客户查询操作--searchCustomer.do");
        List<Customer> cList = customerService.searchCustomer(c);
        return cList;
    }

    @ResponseBody
    @RequestMapping("/delete.do")
    public boolean delete(@RequestParam("id") String[] ids) {
        System.out.println("删除客户操作---delete.do");
       boolean flag = customerService.delete(ids);
       return flag;

    }

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> getUserList(){
        System.out.println("获取用户---getUserList.do");

        List<User> uList = userService.getUserList();
        return uList;

    }


    @ResponseBody
    @RequestMapping("/save.do")
    public boolean save(Customer c, HttpSession session){
        System.out.println("添加客户操作---save.do");

        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)session.getAttribute("user")).getName();

        c.setId(id);
        c.setCreateBy(createBy);
        c.setCreateTime(createTime);

        boolean flag = customerService.save(c);

        return flag;

    }



    @ResponseBody
    @RequestMapping("/getUserListAndCustomer.do")
    public  Map<String,Object> getUserListAndCustomer(String id){
        System.out.println("获取用户和客户---getUserListAndCustomer.do");

        Map<String,Object> map = customerService.getUserListAndCustomer(id);
        return map;

    }



    @ResponseBody
    @RequestMapping("/update.do")
    public boolean update(Customer c,HttpSession session){
        System.out.println("修改客户数据---update.do");

        // 修改时间: 当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        // 修改人: 当前登录用户
        String editBy = ((User) session.getAttribute("user")).getName();

        c.setEditTime(editTime);
        c.setEditBy(editBy);

        boolean flag = customerService.update(c);

        return flag;

    }


    @ResponseBody
    @RequestMapping("/detail.do")
    public void detail(String id ,HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("跳转到客户详细信息页---detail.do");

        Customer customer = customerService.detail(id);
        request.setAttribute("customer",customer);

        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);

    }

    @ResponseBody
    @RequestMapping("/getRemarkListById.do")
    public List<CustomerRemark> getRemarkListById(CustomerRemark customerId){
        System.out.println("根据客户Id查询备注---getRemarkListById.do");

        List<CustomerRemark> cusList = customerService.getRemarkListById(customerId);
        return cusList;

    }



    @ResponseBody
    @RequestMapping("/saveRemark.do")
    public Map<String,Object> saveRemark(CustomerRemark cr ,HttpSession session){
        System.out.println("保存客户备注---saveRemark.do");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)session.getAttribute("user")).getName();
        String editFlag = "0";

        cr.setCreateBy(createBy);
        cr.setCreateTime(createTime);
        cr.setId(id);
        cr.setEditFlag(editFlag);

       boolean flag = customerService.saveRemark(cr);

        Map<String, Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("cr",cr);

        return map;

    }




    @ResponseBody
    @RequestMapping("/updateRemarkById.do")
    public boolean updateRemarkById(HttpSession session,CustomerRemark cr){
        System.out.println("修改客户备注---updateRemarkById.do");

        // 修改时间: 当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        // 修改人: 当前登录用户
        String editBy = ((User) session.getAttribute("user")).getName();
        String editFlag = "1";

        cr.setEditFlag(editFlag);
        cr.setEditBy(editBy);
        cr.setEditTime(editTime);


      boolean flag = customerService.updateRemarkById(cr);
      return flag;

    }

    @ResponseBody
    @RequestMapping("/deleteRemark.do")
    public boolean deleteRemark(String id){
        System.out.println("删除客户备注---deleteRemark.do");

        boolean flag = customerService.deleteRemark(id);
        return flag;

    }



    @ResponseBody
    @RequestMapping("/searchTransaction.do")
    public List<Tran> searchTransaction(Tran customerId, HttpSession session){
        System.out.println("搜索客户相关的交易---searchTransaction.do");


        List<Tran> tList = tranService.searchTransaction(customerId);

        //阶段和可能性之间的对应关系(Map<String, String>) request.getServletContext().getAttribute("pMap");
        Map<String,String> pMap = (Map<String, String>) session.getServletContext().getAttribute("pMap");

        //将交易遍历
        for(Tran th : tList){

            //根据每条交易，取出每一个阶段
            String stage = th.getStage();
            String possibility = pMap.get(stage);
            th.setPossibility(possibility);

        }
        return tList;

    }



    @ResponseBody
    @RequestMapping("/getContactsByCustomerId.do")
    public List<Contacts> getContactsByCustomerId(Contacts customerId){
        System.out.println("显示联系人---getContactsByCustomerId.do");

        List<Contacts> contactsList = contactsService.getContactsByCustomerId(customerId);
        return contactsList;

    }

}
