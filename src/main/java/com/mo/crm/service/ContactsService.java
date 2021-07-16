package com.mo.crm.service;

import com.mo.crm.domain.Contacts;
import com.mo.crm.domain.ContactsRemark;
import com.mo.crm.domain.Tran;
import com.mo.crm.domain.User;
import com.mo.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    List<Contacts> getContactsByCustomerId(Contacts customerId);

    PaginationVO<Contacts> getContactsList(Map<String, Object> map);

    Contacts detail(String id);

    List<User> getUserList();


    boolean saveContacts(Contacts contacts, String customerName);

    Map<String, Object> getUserListAndContacts(String id);

    boolean updateContactsById(Contacts c, String customerName);

    boolean deleteContactsById(String[] ids);

    List<Contacts> searchContactsByCondition(Contacts con);

    List<Tran> getContactsTranList(Tran contactsId);

    boolean unbundActivity(String id);

    boolean bundActivity(String cid, String[] aid);

    List<ContactsRemark> getRemarkByContacts(String contactsId);

    boolean deleteRemark(String id);

    boolean updateRemarkById(ContactsRemark cr);

    boolean saveRemark(ContactsRemark cr);
}
