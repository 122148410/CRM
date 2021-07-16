package com.mo.crm.dao;

import com.mo.crm.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {

    int save(ContactsRemark contactsRemark);

    List<ContactsRemark> getRemarkByContacts(String contactsId);

    boolean deleteRemark(String id);

    boolean updateRemarkById(ContactsRemark cr);
}
