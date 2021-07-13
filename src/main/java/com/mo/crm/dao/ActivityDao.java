package com.mo.crm.dao;

import com.mo.crm.domain.Activity;
import com.mo.crm.domain.Clue;
import com.mo.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface ActivityDao {


    int getTotalByCondition(Map<String, Object> map);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int save(Activity a);

    Activity detail(String id);

    Activity getById(String id);

    int update(Activity a);

    int delete(String[] ids);


    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);
}
