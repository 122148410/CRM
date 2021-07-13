package com.mo.crm.service;

import com.mo.crm.domain.DicValue;

import javax.servlet.ServletContext;
import java.util.List;
import java.util.Map;

public interface DicService {
    Map<String, List<DicValue>> getAll(ServletContext application);
}
