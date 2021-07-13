package com.mo.crm.service.impl;

import com.mo.crm.dao.CustomerDao;
import com.mo.crm.dao.TranDao;
import com.mo.crm.dao.TranHistoryDao;
import com.mo.crm.dao.UserDao;
import com.mo.crm.domain.*;
import com.mo.crm.service.TranService;
import com.mo.crm.utils.DateTimeUtil;
import com.mo.crm.utils.UUIDUtil;
import com.mo.crm.vo.PaginationVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranDao tranDao ;

    @Autowired
    private TranHistoryDao tranHistoryDao;

    @Autowired
    private CustomerDao customerDao;

    @Autowired
    private UserDao userDao;

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {

        List<TranHistory> thList = tranHistoryDao.getHistoryListByTranId(tranId);

        return thList;
    }

    @Override
    public boolean save(Tran t, String customerName) {

        /*

            交易添加业务：

                在做添加之前，参数t里面就少了一项信息，就是客户的主键，customerId

                先处理客户相关的需求

                （1）判断customerName，根据客户名称在客户表进行精确查询
                       如果有这个客户，则取出这个客户的id，封装到t对象中
                       如果没有这个客户，则再客户表新建一条客户信息，然后将新建的客户的id取出，封装到t对象中

                （2）经过以上操作后，t对象中的信息就全了，需要执行添加交易的操作

                （3）添加交易完毕后，需要创建一条交易历史



         */

        boolean flag = true;

        Customer cus = customerDao.getCustomerByName(customerName);

        //如果cus为null，需要创建客户
        if(cus==null){

            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateBy(t.getCreateBy());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setContactSummary(t.getContactSummary());
            cus.setNextContactTime(t.getNextContactTime());
            cus.setOwner(t.getOwner());
            //添加客户
            int count1 = customerDao.save(cus);
            if(count1!=1){
                flag = false;
            }

        }

        //通过以上对于客户的处理，不论是查询出来已有的客户，还是以前没有我们新增的客户，总之客户已经有了，客户的id就有了
        //将客户id封装到t对象中
        t.setCustomerId(cus.getId());

        //添加交易
        int count2 = tranDao.save(t);
        if(count2!=1){
            flag = false;
        }

        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());
        int count3 = tranHistoryDao.save(th);
        if(count3!=1){
            flag = false;
        }

        return flag;
    }

    @Override
    public Tran detail(String id) {
        Tran t = tranDao.detail(id);
        return t;
    }

    @Override
    public boolean changeStage(Tran t) {
        boolean flag = true;

        //改变交易阶段
       int count = tranDao.changeStage(t);
        if (count != 1) {
            flag = false;
        }

        //交易阶段改变后，生成一条交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(t.getEditTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setPossibility(t.getPossibility());

        int count2 = tranHistoryDao.save(th);
        if (count2 != 1) {
            flag = false;
        }
            return flag;
    }

    @Override
    public Map<String, Object> getCharts() {
        //取得total
        int total = tranDao.getTotal();

        //取得dataList
        List<Map<String,Object>> dataList = tranDao.getCharts();

        //将total和dataList保存到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("total", total);
        map.put("dataList", dataList);

        //返回map
        return map;

    }

    @Override
    public PaginationVO<Tran> pageTransactionList(Map<String, Object> map) {

        //取得total
       int total = tranDao.getTranTotalByCondition(map);

       List<Tran> dataList = tranDao.getTranListByCondition(map);

        PaginationVO<Tran> vo = new PaginationVO<Tran>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public List<Tran> transactionQuery(Tran t) {
        List<Tran> tranList = tranDao.transactionQuery(t);
        return tranList;
    }

    @Override
    public Tran transactionUpdate(String id) {

        Tran tranList = tranDao.selectTranById(id);

        return tranList;
    }


    @Override
    public Map<String, Object> searchTranById(String id) {

        //取uList
        List<User> usList = userDao.getUserList();

        Tran t = tranDao.searchTranById(id);
        Map<String, Object> map = new HashMap<>();
        map.put("t",t);
        map.put("usList",usList);
        return map;
    }

    @Override
    public List<Tran> searchTransaction(Tran customerId) {

        List<Tran> tranList = tranDao.searchTransaction(customerId);
        return tranList;
    }

    @Override
    public Tran searchTran(String id) {
        Tran tran = tranDao.searchTran(id);

        return tran;
    }

    @Override
    public boolean updateTranById(Tran t) {
        boolean flag = true;

        //改变交易阶段
        int count = tranDao.updateTranById(t);
        if (count != 1) {
            flag = false;
        }

        return flag;
    }

    @Override
    public Tran searchTranId(String id) {
        Tran t = tranDao.searchTranId(id);

        return t;
    }

    @Override
    public boolean delete(String[] ids) {

        boolean flag = tranDao.delete(ids);

        return flag;
    }

    @Override
    public boolean unbundTrans(String id) {
       boolean flag = tranDao.unbundTrans(id);
        return flag;
    }


}
