package com.mo.crm.controller;


import com.mo.crm.domain.Activity;
import com.mo.crm.domain.Contacts;
import com.mo.crm.domain.Tran;
import com.mo.crm.domain.User;
import com.mo.crm.service.ContactsService;
import com.mo.crm.service.TranService;
import com.mo.crm.utils.DateTimeUtil;
import com.mo.crm.utils.UUIDUtil;
import com.mo.crm.vo.PaginationVO;
import org.omg.CORBA.PRIVATE_MEMBER;
import org.springframework.beans.factory.annotation.Autowired;
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
@RequestMapping("/workbench/contacts")
public class ContactsController {

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private TranService tranService;


    @ResponseBody
    @RequestMapping("/getContactsList.do")
    public PaginationVO<Contacts> getContactsList(HttpServletRequest request, Contacts contacts) {
        System.out.println("显示联系人列表---getContactsList.do");

        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);
        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizeStr);
        //计算出略过的记录数
        int skipCount = (pageNo - 1) * pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        map.put("contacts", contacts);

        PaginationVO<Contacts> vo = contactsService.getContactsList(map);

        return vo;

    }


    @ResponseBody
    @RequestMapping("/detail.do")
    public void detail(HttpServletRequest request, HttpServletResponse response, String id) throws ServletException, IOException {
        System.out.println("显示联系人详细列表---detail.do");

        Contacts con = contactsService.detail(id);
        request.setAttribute("con", con);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request, response);
    }


    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> getUserList() {
        System.out.println("查找用户---getUserList.do");

        List<User> uList = contactsService.getUserList();
        return uList;
    }


    @ResponseBody
    @RequestMapping("/saveContacts.do")
    public boolean saveContacts(HttpSession session, Contacts contacts, HttpServletRequest request) {
        System.out.println("保存联系人-=-=-saveContacts.do");

        String customerName = request.getParameter("customerName");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User) session.getAttribute("user")).getName();
        String id = UUIDUtil.getUUID();

        contacts.setId(id);
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);


        boolean flag = contactsService.saveContacts(contacts, customerName);

        return flag;
    }


    @ResponseBody
    @RequestMapping("/getUserListAndContacts.do")
    public Map<String, Object> getUserListAndContacts(String id) {
        System.out.println("查找联系人---getUserListAndContacts.do");

        Map<String, Object> map = contactsService.getUserListAndContacts(id);
        return map;
    }


    @ResponseBody
    @RequestMapping("/updateContactsById.do")
    public boolean updateContactsById(HttpServletRequest request,HttpSession session,Contacts c) {
        System.out.println("修改联系人---updateContactsById.do");

        // 修改时间: 当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        // 修改人: 当前登录用户
        String editBy = ((User) session.getAttribute("user")).getName();
        String customerName = request.getParameter("customerName");

        c.setEditTime(editTime);
        c.setEditBy(editBy);

        boolean flag = contactsService.updateContactsById(c,customerName);
        return flag;

    }




    @ResponseBody
    @RequestMapping("/deleteContactsById.do")
    public boolean deleteContactsById(@RequestParam("id") String[] ids) {
        System.out.println("删除联系人=-=-=-=deleteContactsById.do");

     boolean flag = contactsService.deleteContactsById(ids);
     return flag;

    }




    @ResponseBody
    @RequestMapping("/searchContactsByCondition.do")
    public List<Contacts> searchContactsByCondition(Contacts con) {
        System.out.println("根据搜索框条件查询联系人=-=-=-=searchContactsByCondition.do");

        List<Contacts> conList = contactsService.searchContactsByCondition(con);
        return conList;

    }


    @ResponseBody
    @RequestMapping("/getContactsTranList.do")
    public List<Tran> getContactsTranList(HttpSession session,Tran contactsId) {
        System.out.println("查找与联系人有关的交易=-=-=-=getContactsTranList.do");

        List<Tran> tList = contactsService.getContactsTranList(contactsId);

        Map<String,String> pMap = (Map<String, String>) session.getServletContext().getAttribute("pMap");

        for (Tran t : tList) {

            String stage = t.getStage();
            String possibility = pMap.get(stage);
            t.setPossibility(possibility);

        }
        return tList;

    }




    @ResponseBody
    @RequestMapping("/unbundTrans.do")
    public boolean unbundTrans(String id) {
        System.out.println("解除联系人中的交易=-=-=-=unbundTrans.do");

        boolean flag = tranService.unbundTrans(id);

        return flag;

    }





}