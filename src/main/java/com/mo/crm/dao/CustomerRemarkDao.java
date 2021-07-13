package com.mo.crm.dao;

import com.mo.crm.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    int save(CustomerRemark customerRemark);

    List<CustomerRemark> getRemarkListById(CustomerRemark customerId);

    int saveRemark(CustomerRemark cr);

    int updateRemarkById(CustomerRemark cr);

    int deleteRemark(String id);
}
