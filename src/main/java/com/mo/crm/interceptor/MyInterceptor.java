package com.mo.crm.interceptor;


import com.mo.crm.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.FilterChain;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class MyInterceptor implements HandlerInterceptor {


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        System.out.println("执行方法=-=-=-=-=————+++preHandle-preHandle-preHandle");
        //String path = request.getServletPath();


        //执行前的拦截, 返回的是false表示拦截, 返回的是true表示不拦截
        System.out.println("=====preHandle======");
        if (request.getSession().getAttribute("user") != null) {
            return true;
        }else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
       /* if (request.getRequestURI().contains("/login.jsp") || request.getRequestURI().contains("/crm/user/login.do")) {
            return true;
        }*/
        //不能放行, 返回到首页



    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("执行方法=-=-=-=-=————+++postHandle-postHandle-postHandle");
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("执行方法=-=-=-=-=————+++afterCompletion-afterCompletion-afterCompletion");
    }
}
