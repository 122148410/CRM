package com.mo.crm.service.impl;

import com.mo.crm.dao.UserDao;
import com.mo.crm.domain.User;
import com.mo.crm.exception.LoginException;
import com.mo.crm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd) throws LoginException {
        Map<String,String> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        User user = userDao.login(map);

        if (user == null) {
            throw new LoginException("账号密码错误");
        }

        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> uList = userDao.getUserList();
        return uList;
    }

}
