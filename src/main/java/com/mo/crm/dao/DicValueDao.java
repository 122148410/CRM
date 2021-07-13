package com.mo.crm.dao;


import com.mo.crm.domain.DicValue;

import java.util.List;

public interface DicValueDao {

    List<DicValue> getListByCode(String code);

    List<DicValue> getAll();

    List<DicValue> getListById(String id);
}
