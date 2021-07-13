package com.mo.crm.dao;


import com.mo.crm.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    int bund(ClueActivityRelation car);

    int unbund(String id);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int delete(ClueActivityRelation clueActivityRelation);
}
