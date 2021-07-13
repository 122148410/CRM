package com.mo.crm.service.impl;

import com.mo.crm.dao.ContactsDao;
import com.mo.crm.dao.CustomerDao;
import com.mo.crm.dao.TranDao;
import com.mo.crm.dao.UserDao;
import com.mo.crm.domain.Contacts;
import com.mo.crm.domain.Customer;
import com.mo.crm.domain.Tran;
import com.mo.crm.domain.User;
import com.mo.crm.service.ContactsService;
import com.mo.crm.utils.DateTimeUtil;
import com.mo.crm.utils.UUIDUtil;
import com.mo.crm.vo.PaginationVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class ContactsServiceImpl implements ContactsService {


    @Autowired
    private ContactsDao contactsDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private CustomerDao customerDao;

    @Autowired
    private TranDao tranDao;


    @Override
    public List<Contacts> getContactsByCustomerId(Contacts customerId) {
        List<Contacts> contactsList = contactsDao.getContactsByCustomerId(customerId);
        return contactsList;
    }

    @Override
    public PaginationVO<Contacts> getContactsList(Map<String, Object> map) {


        //取得total
        int total = contactsDao.getTotalByCondition(map);
        //取得dataList
        List<Contacts> dataList = contactsDao.getContactsListByCondition(map);
        //创建一个vo对象，将total和dataList封装到vo中
        PaginationVO<Contacts> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        //将vo返回
        return vo;
    }

    @Override
    public Contacts detail(String id) {
       Contacts con = contactsDao.detail(id);
        return con;
    }

    @Override
    public List<User> getUserList() {
        List<User> uList = userDao.getUserList();
        return uList;
    }

    @Override
    public boolean saveContacts(Contacts contacts, String customerName) {

        boolean flag = true;

        Customer cus = customerDao.getCustomerByName(customerName);

            //如果cus为null，需要创建客户
            if(cus==null){

                cus = new Customer();
                cus.setId(UUIDUtil.getUUID());
                cus.setName(customerName);
                cus.setCreateBy(contacts.getCreateBy());
                cus.setCreateTime(DateTimeUtil.getSysTime());
                cus.setContactSummary(contacts.getContactSummary());
                cus.setNextContactTime(contacts.getNextContactTime());
                cus.setOwner(contacts.getOwner());
                //添加客户
                int count1 = customerDao.save(cus);
                if(count1!=1){
                    flag = false;
                }

            }
            contacts.setCustomerId(cus.getId());

           int count = contactsDao.save(contacts);
        if (count != 1) {
            flag = false;
        }

        return flag;

    }

    @Override
    public Map<String, Object> getUserListAndContacts(String id) {
        //获取用户
        List<User> uList = userDao.getUserList();

        Contacts con = contactsDao.getContactsById(id);
        Contacts cusId = contactsDao.getCustomerId(id);
        Map<String, Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("con",con);
        map.put("cusId",cusId);
        return map;
    }

    @Override
    public boolean updateContactsById(Contacts c, String customerName) {

        boolean flag = true;
        Customer cus = customerDao.getCustomerByName(customerName);
        //如果cus为null，需要创建客户
        if(cus==null){

            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(c.getCreateBy());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setContactSummary(c.getContactSummary());
            cus.setNextContactTime(c.getNextContactTime());
            cus.setOwner(c.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if(count1!=1){
                flag = false;
            }

        }
        c.setCustomerId(cus.getId());

        int count = contactsDao.updateContactsById(c);
        if (count != 1) {
            flag = false;
        }

        return flag;

    }

    @Override
    public boolean deleteContactsById(String[] ids) {

       boolean flag = contactsDao.deleteContactsById(ids);
        return flag;
    }

    @Override
    public List<Contacts> searchContactsByCondition(Contacts con) {
        List<Contacts> conList = contactsDao.searchContactsByCondition(con);
        return conList;
    }

    @Override
    public List<Tran> getContactsTranList(Tran contactsId) {
        List<Tran> tList = tranDao.getContactsTranList(contactsId);
        return tList;
    }
}
