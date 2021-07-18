package com.mo.crm.controller;

import com.mo.crm.domain.Activity;
import com.mo.crm.domain.Clue;
import com.mo.crm.domain.Tran;
import com.mo.crm.domain.User;
import com.mo.crm.service.ActivityService;
import com.mo.crm.service.ClueService;
import com.mo.crm.service.UserService;
import com.mo.crm.utils.DateTimeUtil;
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
@RequestMapping("/workbench/clue")
public class ClueController {

  @Autowired
  private ClueService clueService;

   @Autowired
   private UserService userService;

    @Autowired
    private ActivityService activityService;

    @ResponseBody
    @RequestMapping("/getUserList.do")
    public List<User> getUserList(){

        System.out.println("取得用户信息列表");

        List<User> uList = userService.getUserList();

       return uList;
    }

    @ResponseBody
    @RequestMapping("/save.do")
    public boolean save(HttpSession session,Clue c){
        System.out.println("执行线索添加操作");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)session.getAttribute("user")).getName();

        c.setId(id);
        c.setCreateTime(createTime);
        c.setCreateBy(createBy);

       boolean flag = clueService.save(c);
       return flag;
    }

    @ResponseBody
    @RequestMapping("/pageClueList.do")
    public PaginationVO<Clue> pageClueList(HttpServletRequest request){

        System.out.println("查询线索（结合条件查询+分页查询）");

        String fullname=request.getParameter("fullname");
        String company=request.getParameter("company");
        String phone=request.getParameter("phone");
        String mphone=request.getParameter("mphone");
        String owner=request.getParameter("owner");
        String source=request.getParameter("source");
        String state=request.getParameter("state");
        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);
        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizeStr);
        //计算出略过的记录数
        int skipCount = (pageNo-1)*pageSize;


        Map<String, Object> map = new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("owner",owner);
        map.put("source",source);
        map.put("state",state);

        PaginationVO<Clue> vo = clueService.pageClueList(map);

        return vo;

    }
     @ResponseBody
     @RequestMapping("/detail.do")
     public void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
         System.out.println("跳转到线索详细信息页");
         String id = request.getParameter("id");
         Clue c = clueService.detail(id);
         request.setAttribute("c", c);
         request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request, response);


     }

    @ResponseBody
    @RequestMapping("/getActivityListByClueId.do")
     public List<Activity> getActivityListByClueId(HttpServletRequest request){
        System.out.println("根据线索id查询关联的市场活动列表");
        String clueId = request.getParameter("clueId");
        List<Activity> aList = activityService.getActivityListByClueId(clueId);
        return aList;
    }
    @ResponseBody
    @RequestMapping("/getActivityListByNameAndNotByClueId.do")
    public List<Activity> getActivityListByNameAndNotByClueId(HttpServletRequest request){
        System.out.println("查询市场活动列表（根据名称模糊查+排除掉已经关联指定线索的列表）");
        String clueId = request.getParameter("clueId");
        String aname = request.getParameter("aname");

        Map<String,String> map = new HashMap<String,String>();
        map.put("aname", aname);
        map.put("clueId", clueId);

        List<Activity> aList = activityService.getActivityListByNameAndNotByClueId(map);
        return aList;
    }
    @ResponseBody
    @RequestMapping("/bund.do")
    public boolean bund(HttpServletRequest request){
        System.out.println("执行关联市场活动的操作");

        String cid = request.getParameter("cid");
        String aids[] = request.getParameterValues("aid");

       boolean flag = clueService.bund(cid,aids);
       return flag;
    }

    @ResponseBody
    @RequestMapping("/unbund.do")
    public boolean unbund(HttpServletRequest request){
        System.out.println("执行解除关联市场活动的操作");
        String id =request.getParameter("id");
      boolean flag = clueService.unbund(id);
        return flag;
    }

    @ResponseBody
    @RequestMapping("/getActivityListByName.do")
    public List<Activity> getActivityListByName(HttpServletRequest request){
        System.out.println("查询市场活动列表（根据名称模糊查）");
        String aname = request.getParameter("aname");
        List<Activity> aList = activityService.getActivityListByName(aname);
       return aList;
    }

    @ResponseBody
    @RequestMapping("/convert.do")
    public void convert(HttpSession session, HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("执行线索转换的操作");

        String clueId = request.getParameter("clueId");

        //接收是否需要创建交易的标记
        String flag = request.getParameter("flag");

        String createBy = ((User)session.getAttribute("user")).getName();

        Tran t = null;

        //如果需要创建交易
        if("a".equals(flag)){

            t = new Tran();

            //接收交易表单中的参数
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            String id = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();


            t.setId(id);
            t.setMoney(money);
            t.setName(name);
            t.setExpectedDate(expectedDate);
            t.setStage(stage);
            t.setActivityId(activityId);
            t.setCreateBy(createBy);
            t.setCreateTime(createTime);

        }


        /*

            为业务层传递的参数：

            1.必须传递的参数clueId，有了这个clueId之后我们才知道要转换哪条记录
            2.必须传递的参数t，因为在线索转换的过程中，有可能会临时创建一笔交易（业务层接收的t也有可能是个null）

         */
        boolean flag1 = clueService.convert(clueId,t,createBy);

        if(flag1){

            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");

        }

    }


    @ResponseBody
    @RequestMapping("/editClueById.do")
    public Map<String ,Object> editClueById(HttpServletRequest request,String id){
        System.out.println("执行修改的操作");

        Clue c = clueService.getClueById(id);
        request.setAttribute("c",c);

        Map<String ,Object> map = clueService.getById(id);
        return map;
    }


    @ResponseBody
    @RequestMapping("/deleteClueById.do")
    public boolean deleteClueById(@RequestParam("id") String[] id){
        System.out.println("执行线索删除的操作--=-=-=-=deleteClueById.do");

       boolean flag = clueService.deleteClueById(id);

        return flag;
    }

    @ResponseBody
    @RequestMapping("/updateClueById.do")
    public boolean updateClueById(HttpSession session,Clue c){
        System.out.println("执行更新线索的操作--=-=-=-=updateClueById.do");

        // 修改时间: 当前系统时间
        String editTime = DateTimeUtil.getSysTime();
        // 修改人: 当前登录用户
        String editBy = ((User) session.getAttribute("user")).getName();

        c.setEditBy(editBy);
        c.setEditTime(editTime);

        boolean flag = clueService.updateClueById(c);

        return flag;
    }


    @ResponseBody
    @RequestMapping("/getClueByCondition.do")
    public List<Clue> getClueByCondition(Clue c ){
        System.out.println("查询线索-=-=-=-=-=getClueByCondition.do");

       List<Clue> list = clueService.getClueByCondition(c);
       return  list;
    }




}
