package com.mo.crm.service;

import com.mo.crm.domain.Clue;
import com.mo.crm.domain.Tran;
import com.mo.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue c);

    PaginationVO<Clue> pageClueList(Map<String, Object> map);

    Clue detail(String id);

    boolean bund(String cid, String[] aids);

    boolean unbund(String id);

    boolean convert(String clueId, Tran t, String createBy);

    Map<String, Object> getById(String id);

    Clue getClueById(String id);

    boolean deleteClueById(String[] id);


    boolean updateClueById(Clue c);

    List<Clue> getClueByCondition(Clue c);
}
