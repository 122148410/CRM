package com.mo.crm.service.impl;

import com.mo.crm.dao.DicTypeDao;
import com.mo.crm.dao.DicValueDao;
import com.mo.crm.domain.DicType;
import com.mo.crm.domain.DicValue;
import com.mo.crm.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.ServletContext;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DicServiceImpl implements DicService {

    @Autowired
    private DicValueDao dicValueDao;

    @Autowired
    private DicTypeDao dicTypeDao;

    @Override
    public Map<String, List<DicValue>> getAll(ServletContext application) {
        Map<String, List<DicValue>> map = new HashMap<String, List<DicValue>>();

        //将字典类型列表取出
        List<DicType> dtList = dicTypeDao.getTypeList();

        //将字典类型列表遍历
        for(DicType dt : dtList){

            //取得每一种类型的字典类型编码
            String code = dt.getCode();

            //根据每一个字典类型来取得字典值列表
            List<DicValue> dvList = dicValueDao.getListByCode(code);

            map.put(code+"List", dvList);

        }

        return map;
    }
}
