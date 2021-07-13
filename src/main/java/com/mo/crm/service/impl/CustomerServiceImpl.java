package com.mo.crm.service.impl;

import com.mo.crm.dao.CustomerDao;
import com.mo.crm.dao.CustomerRemarkDao;
import com.mo.crm.dao.UserDao;
import com.mo.crm.domain.Customer;
import com.mo.crm.domain.CustomerRemark;
import com.mo.crm.domain.User;
import com.mo.crm.service.CustomerService;
import com.mo.crm.vo.PaginationVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private UserDao userDao;

    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private CustomerRemarkDao customerRemarkDao;

    @Override
    public List<String> getCustomerName(String name) {
        List<String> sList = customerDao.getCustomerName(name);
        return sList;
    }

    @Override
    public PaginationVO<Customer> pageCustomerList(Map<String, Object> map) {

        //取得total
         int total = customerDao.getTotalByCondition(map);
        //取得dataList
        List<Customer> dataList = customerDao.getCustomerListByCondition(map);
        //创建一个vo对象，将total和dataList封装到vo中
        PaginationVO<Customer> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        //将vo返回
        return vo;
    }

    @Override
    public List<Customer> searchCustomer(Customer c) {
        List<Customer> cList = customerDao.searchCustomer(c);
        return cList;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = customerDao.delete(ids);
        return flag;
    }

    @Override
    public boolean save(Customer c) {
        boolean flag = true;

        int count = customerDao.save(c);
        if (count != 1) {
            flag = false;
        }

        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndCustomer(String id) {

        List<User> uList = userDao.getUserList();

        Customer customer = customerDao.getCustomerById(id);
        Map<String, Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("customer",customer);

        return map;
    }

    @Override
    public boolean update(Customer c) {
        boolean flag = true;

        int count = customerDao.update(c);
        if (count != 1) {
            flag = false;
        }

        return flag;
    }

    @Override
    public Customer detail(String id) {
       Customer customer = customerDao.detail(id);
        return customer;
    }

    @Override
    public List<CustomerRemark> getRemarkListById(CustomerRemark customerId) {
        List<CustomerRemark> cusList = customerRemarkDao.getRemarkListById(customerId);
        return cusList;
    }

    @Override
    public boolean saveRemark(CustomerRemark cr) {
        boolean flag = true;

        int count =  customerRemarkDao.saveRemark(cr);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean updateRemarkById(CustomerRemark cr) {

        boolean flag = true;

        int count =  customerRemarkDao.updateRemarkById(cr);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;

        int count =  customerRemarkDao.deleteRemark(id);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }


}
