package com.mo.crm.service;

import com.mo.crm.domain.User;
import com.mo.crm.exception.LoginException;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd);

    List<User> getUserList();

}
