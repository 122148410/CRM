package com.mo.crm.service;

import com.mo.crm.domain.Tran;
import com.mo.crm.domain.TranHistory;
import com.mo.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface TranService {

    List<TranHistory> getHistoryListByTranId(String tranId);

    boolean save(Tran t, String customerName);

    Tran detail(String id);

    boolean changeStage(Tran t);

    Map<String, Object> getCharts();

    PaginationVO<Tran> pageTransactionList(Map<String, Object> map);

    List<Tran> transactionQuery(Tran t);

    Tran transactionUpdate(String id);

    Map<String, Object> searchTranById(String id);

    List<Tran> searchTransaction(Tran customerId);

    Tran searchTran(String id);

    boolean updateTranById( Tran t);

    Tran searchTranId(String id);

    boolean delete(String[] ids);


    boolean unbundTrans(String id);
}
