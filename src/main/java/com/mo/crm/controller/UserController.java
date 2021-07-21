package com.mo.crm.controller;

import com.mo.crm.domain.User;
import com.mo.crm.exception.LoginException;
import com.mo.crm.service.UserService;
import com.mo.crm.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Resource
    private UserService userService;


    @RequestMapping("/crm/user/login.do")
    @ResponseBody
    public boolean login(HttpSession session, User user){
        System.out.println("进入到用户登陆的控制器");
        System.out.println("进入到验证登录操作");

        String loginAct = user.getLoginAct();
        String loginPwd =user.getLoginPwd();
         loginPwd = MD5Util.getMD5(loginPwd);

        user = userService.login(loginAct,loginPwd);
        session.setAttribute("user", user);

      // Map<String,Object> map = new HashMap<>();


       boolean flag = true;
       if (user!=null) {
           flag = true;
        }else{
            flag = false;
        }
         return flag;
    }

}
