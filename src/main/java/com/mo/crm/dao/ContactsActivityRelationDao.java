package com.mo.crm.dao;

import com.mo.crm.domain.ContactsActivityRelation;
import com.mo.crm.domain.Tran;

public interface ContactsActivityRelationDao {

    int save(ContactsActivityRelation contactsActivityRelation);


    String select(String contactsId, String activityId);

    boolean unbundActivity(String reid);
}
