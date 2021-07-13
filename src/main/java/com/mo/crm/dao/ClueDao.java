package com.mo.crm.dao;


import com.mo.crm.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int save(Clue c);


    List<Clue> getClueListByCondition(Map<String, Object> map);

    int getClueTotalByCondition(Map<String, Object> map);

    Clue detail(String id);


    Clue getById(String clueId);

    int delete(String clueId);

    Clue editClueById(String id);

    boolean deleteClueById(String[] id);


    boolean updateClueById(Clue c);

    List<Clue> getClueByCondition(Clue c);
}
