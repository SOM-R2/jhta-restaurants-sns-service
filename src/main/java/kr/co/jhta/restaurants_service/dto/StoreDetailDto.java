package kr.co.jhta.restaurants_service.dto;

import java.util.List;

import kr.co.jhta.restaurants_service.vo.store.Food;
import kr.co.jhta.restaurants_service.vo.store.Store;
import kr.co.jhta.restaurants_service.vo.store.StoreOpenTime;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class StoreDetailDto {

	private Store store;
	private List<Food> foods;
	private List<StoreOpenTime> openTimes;
	private List<Store> closestStores;

	public StoreDetailDto(Store store, List<Food> foods, List<StoreOpenTime> openTimes) {
		this.store = store;
		this.foods = foods;
		this.openTimes = openTimes;
	}
}
