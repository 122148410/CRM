package com.mo.crm.controller;

import com.mo.crm.domain.Activity;
import com.mo.crm.domain.ActivityRemark;
import com.mo.crm.domain.User;
import com.mo.crm.service.ActivityService;
import com.mo.crm.service.UserService;
import com.mo.crm.utils.DateTimeUtil;
import com.mo.crm.utils.UUIDUtil;
import com.mo.crm.vo.PaginationVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import sun.util.calendar.LocalGregorianCalendar;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequestMapping(value = "/workbench/activity")
@Controller
public class ActivityController {

    @Resource
    private UserService userService;

    @Resource
    private ActivityService activityService;

    @RequestMapping("/getUserList.do")
    @ResponseBody
    public List<User> getUserList(){
        System.out.println("获取用户列表");
        List<User> uList = userService.getUserList();
        return uList;
    }

    @RequestMapping("/pageList")
    @ResponseBody
    public PaginationVO<Activity> pageList(HttpServletRequest request, Activity activity){
        System.out.println("进入到查询市场活动信息列表的操作（结合条件查询+分页查询）");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String pageNoStr = request.getParameter("pageNo");
        int pageNo = Integer.valueOf(pageNoStr);
        //每页展现的记录数
        String pageSizeStr = request.getParameter("pageSize");
        int pageSize = Integer.valueOf(pageSizeStr);
        //计算出略过的记录数
        int skipCount = (pageNo-1)*pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        PaginationVO<Activity> vo = activityService.pageList(map);

        return vo;

    }


    @RequestMapping("/save.do")
    @ResponseBody
    public boolean save(HttpSession session, Activity a){
        System.out.println("进入到市场活动控制器");
        System.out.println("执行市场活动的添加操作");

        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy =((User)session.getAttribute("user")).getName();

        a.setCreateTime(createTime);
        a.setCreateBy(createBy);
        a.setId(id);
        boolean flag =activityService.save(a);

        return flag;
    }

    @ResponseBody
    @RequestMapping("/detail.do")
    public void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到市场活动控制器");
        System.out.println("进入到跳转到详细信息页的操作");
        String id = request.getParameter("id");
        Activity a =activityService.detail(id);
        request.setAttribute("a",a);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);

    }


    @ResponseBody
    @RequestMapping("/getUserListAndActivity.do")
    public Map<String,Object> getUserListAndActivity(String id){

        System.out.println("进入到查询用户信息列表和根据市场活动id查询单条记录的操作");
        /*
            总结：
                controller调用service的方法，返回值应该是什么
                你得想一想前端要什么，就要从service层取什么

            前端需要的，管业务层去要
            uList
            a
            以上两项信息，复用率不高，我们选择使用map打包这两项信息即可
            map
         */
        Map<String,Object> map = activityService.getUserListAndActivity(id);
        return map;
    }

     @ResponseBody
     @RequestMapping("/update.do")
    public boolean update(HttpSession session, Activity a){
         System.out.println("执行市场活动修改操作");

         String editTime = DateTimeUtil.getSysTime();
         String editBy = ((User) session.getAttribute("user")).getName();

         a.setEditBy(editBy);
         a.setEditTime(editTime);

         boolean flag = activityService.update(a);

         return flag;
     }

     @ResponseBody
     @RequestMapping("/delete.do")
     public boolean delete(@RequestParam("id") String[] ids){
         System.out.println("执行市场活动的删除操作");
         boolean flag = activityService.delete(ids);
         return  flag;
     }


    @ResponseBody
    @RequestMapping("/getRemarkListByAid.do")
    public List<ActivityRemark> getRemarkListByAid(ActivityRemark activityId){
       System.out.println("根据市场活动id，取得备注信息列表");
       List<ActivityRemark> arList = activityService.getRemarkListByAid(activityId);
       return  arList;
   }


    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public Map<String,Object> saveRemark(HttpSession session,ActivityRemark ar){

        System.out.println("执行添加备注操作");

        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)session.getAttribute("user")).getName();
        String id = UUIDUtil.getUUID();
        String editFlag = "0";


        ar.setId(id);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setEditFlag(editFlag);


       boolean flag = activityService.saveRemark(ar);
       Map<String,Object> map = new HashMap<String,Object>();
       map.put("success",flag);
       map.put("ar",ar);
        return  map;
    }



    @ResponseBody
    @RequestMapping("/updateRemark.do")
    public Map<String,Object> updateRemark(HttpSession session,ActivityRemark ar){
        System.out.println("执行修改备注的操作");

        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) session.getAttribute("user")).getName();
        String editFlag = "1";

        ar.setEditTime(editTime);
        ar.setEditBy(editBy);
        ar.setEditFlag(editFlag);


        boolean flag = activityService.updateRemark(ar);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success",flag);
        map.put("ar",ar);
        return  map;
    }


    @ResponseBody
    @RequestMapping("/deleteRemark.do")
    public boolean deleteRemark(String id){
       boolean flag = activityService.deleteRemark(id);
       return flag;
    }











}
