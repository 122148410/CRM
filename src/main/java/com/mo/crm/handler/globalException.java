package com.mo.crm.handler;


import com.mo.crm.exception.LoginException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

@ControllerAdvice
public class globalException{

    @ResponseBody
    @ExceptionHandler(value = LoginException.class)
    public String loginException(Exception ex) {
       String msg = ex.getMessage();
       return msg;
    }
}
