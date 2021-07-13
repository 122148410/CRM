package com.mo.crm.dao;


import com.mo.crm.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    List<ActivityRemark> getRemarkListByAid(ActivityRemark activityId);

    int saveRemark(ActivityRemark ar);

    int updateRemark(ActivityRemark ar);

    int deleteRemark(String id);
}
