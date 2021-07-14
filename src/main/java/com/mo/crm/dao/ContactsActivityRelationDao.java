package com.mo.crm.dao;

import com.mo.crm.domain.ClueActivityRelation;
import com.mo.crm.domain.ContactsActivityRelation;
import com.mo.crm.domain.Tran;

public interface ContactsActivityRelationDao {

    int save(ContactsActivityRelation contactsActivityRelation);

    boolean unbundActivity(String id);

    int bund(ContactsActivityRelation car);
}
