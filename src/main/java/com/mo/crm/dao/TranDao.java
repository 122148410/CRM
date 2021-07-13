package com.mo.crm.dao;

import com.mo.crm.domain.Tran;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran t);

    Tran detail(String id);

    int changeStage(Tran t);

    int getTotal();

    List<Map<String, Object>> getCharts();

    List<Tran> getTranListByCondition(Map<String, Object> map);

    int getTranTotalByCondition(Map<String, Object> map);

    List<Tran> transactionQuery(Tran t);

    Tran transactionUpdate(String id);

    Tran searchTranById(String id);

    List<Tran> searchTransaction(Tran customerId);

    Tran selectTranById(String id);

    Tran searchTran(String id);

    int updateTranById(Tran t);

    Tran searchTranId(String id);


    boolean delete(String[] ids);

    List<Tran> getContactsTranList(Tran t);

    boolean unbundTrans(String id);
}
