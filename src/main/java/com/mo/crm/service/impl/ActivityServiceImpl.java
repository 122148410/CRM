package com.mo.crm.service.impl;

import com.mo.crm.dao.ActivityDao;
import com.mo.crm.dao.ActivityRemarkDao;
import com.mo.crm.dao.UserDao;
import com.mo.crm.domain.Activity;
import com.mo.crm.domain.ActivityRemark;
import com.mo.crm.domain.Clue;
import com.mo.crm.domain.User;
import com.mo.crm.service.ActivityService;
import com.mo.crm.vo.PaginationVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao activityDao;

    @Autowired
    private ActivityRemarkDao activityRemarkDao;

    @Autowired
    private UserDao userDao;

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {

        //取得total
        int total = activityDao.getTotalByCondition(map);

        //取得dataList
        List<Activity> dataList = activityDao.getActivityListByCondition(map);
        //创建一个vo对象，将total和dataList封装到vo中
        PaginationVO<Activity> vo = new PaginationVO<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        //将vo返回
        return vo;
    }

    @Override
    public boolean save(Activity a) {
        boolean flag = true;
        int count = activityDao.save(a);
        if(count!=1){
           flag = false;
        }
        return flag;
    }

    @Override
    public Activity detail(String id) {
        Activity a = activityDao.detail(id);
        return a;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {

        //取uList
        List<User> uList = userDao.getUserList();

        //取a
        Activity a = activityDao.getById(id);
        Map<String, Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("a",a);
        return map;
    }

    @Override
    public boolean update(Activity a) {
            boolean flag = true;
            int count = activityDao.update(a);
            if (count != 1) {
                flag = false;
            }
            return flag;
        }

    @Override
    public boolean delete(String[] ids) {
        boolean flag =true;

        //删除市场活动
        int count3 = activityDao.delete(ids);
        if(count3!=ids.length){

            flag = false;

        }
        return flag;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(ActivityRemark activityId) {
        List<ActivityRemark> arList = activityRemarkDao.getRemarkListByAid(activityId);
        return arList;
    }

    @Override
    public boolean saveRemark(ActivityRemark ar) {
        boolean flag =true;
        int count =activityRemarkDao.saveRemark(ar);
        if(count!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean updateRemark(ActivityRemark ar) {
        boolean flag =true;
        int count =activityRemarkDao.updateRemark(ar);
        if(count!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag =true;
        int count = activityRemarkDao.deleteRemark(id);
        if(count!=1){
            flag = false;
        }
        return flag;
    }

    @Override
    public List<Activity> getActivityListByClueId(String clueId) {
        List<Activity> aList = activityDao.getActivityListByClueId(clueId);
        return aList;
    }

    @Override
    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map) {
        List<Activity> aList = activityDao.getActivityListByNameAndNotByClueId(map);
        return aList;
    }

    @Override
    public List<Activity> getActivityListByName(String aname) {
        List<Activity> aList = activityDao.getActivityListByName(aname);
        return aList;
    }


}
