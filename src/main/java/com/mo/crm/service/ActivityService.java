package com.mo.crm.service;

import com.mo.crm.domain.Activity;
import com.mo.crm.domain.ActivityRemark;
import com.mo.crm.domain.Clue;
import com.mo.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface ActivityService {


    PaginationVO<Activity> pageList(Map<String, Object> map);

    boolean save(Activity a);

    Activity detail(String id);

    Map<String, Object> getUserListAndActivity(String id);


    boolean update(Activity a);


    boolean delete(String[] ids);


    List<ActivityRemark> getRemarkListByAid(ActivityRemark activityId);

    boolean saveRemark(ActivityRemark ar);

    boolean updateRemark(ActivityRemark ar);

    boolean deleteRemark(String id);


    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map);

    List<Activity> getActivityListByName(String aname);
}
