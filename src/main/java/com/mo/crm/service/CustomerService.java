package com.mo.crm.service;

import com.mo.crm.domain.Customer;
import com.mo.crm.domain.CustomerRemark;
import com.mo.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    List<String> getCustomerName(String name);

    PaginationVO<Customer> pageCustomerList(Map<String, Object> map);

    List<Customer> searchCustomer(Customer c);

    boolean delete(String[] ids);

    boolean save(Customer c);

    Map<String, Object> getUserListAndCustomer(String id);

    boolean update(Customer c);

    Customer detail(String id);

    List<CustomerRemark> getRemarkListById(CustomerRemark customerId);

    boolean saveRemark(CustomerRemark cr);

    boolean updateRemarkById(CustomerRemark cr);

    boolean deleteRemark(String id);
}
