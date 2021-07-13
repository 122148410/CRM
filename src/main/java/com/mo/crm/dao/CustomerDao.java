package com.mo.crm.dao;

import com.mo.crm.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer cus);

    List<String> getCustomerName(String name);

    List<Customer> getCustomerListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    List<Customer> searchCustomer(Customer c);

    boolean delete(String[] ids);

    Customer getCustomerById(String id);

    int update(Customer c);

    Customer detail(String id);
}
