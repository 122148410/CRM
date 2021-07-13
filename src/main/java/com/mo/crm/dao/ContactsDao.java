package com.mo.crm.dao;

import com.mo.crm.domain.Contacts;
import com.mo.crm.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int save(Contacts con);

    List<Contacts> getContactsByCustomerId(Contacts customerId);

    List<Contacts> getContactsListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    Contacts detail(String id);

    Contacts getContactsById(String id);

    int updateContactsById(Contacts c);

    Contacts getCustomerId(String id);

    boolean deleteContactsById(String[] ids);

    List<Contacts> searchContactsByCondition(Contacts con);
}
