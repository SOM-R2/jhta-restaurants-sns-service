package kr.co.jhta.restaurants_service.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.co.jhta.restaurants_service.vo.Store;

@Mapper
public interface StoreMapper {

	void insertStore(Store store);
	
	List<Store> getStores(Map<String,Object>param);
	
	Store getStoreByNo();
	
	void updateStore(Store store);
	
	List<Store> getAllStores();
	
	int getTotalRows(Map<String,Object> param);
	
}