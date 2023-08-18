package kr.co.jhta.restaurants_service.dto;

import java.util.List;

import kr.co.jhta.restaurants_service.vo.review.Review;
import kr.co.jhta.restaurants_service.vo.review.ReviewKeyword;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ReviewDetailDto {

	private Review review;
	private List<ReviewKeyword> reviewKeywords;
	private List<Review> reviewByCustomerId;
	
	public boolean isTaste() {
		return reviewKeywords
				.stream()
				.map(item -> item.getKeyword())
				.anyMatch(item -> item.equals("#음식이 맛있어요"));
	}
	
	public boolean isParking() {
		return reviewKeywords.stream().map(item -> item.getKeyword()).anyMatch(item -> item.equals("#주차가 편해요"));
	}
	
	public boolean isClean() {
		return reviewKeywords.stream().map(item -> item.getKeyword()).anyMatch(item -> item.equals("#매장이 청결해요"));
	}
	
	public boolean isWide() {
		return reviewKeywords.stream().map(item -> item.getKeyword()).anyMatch(item -> item.equals("#매장이 넓어요"));
	}
	
	public boolean isMood() {
		return reviewKeywords.stream().map(item -> item.getKeyword()).anyMatch(item -> item.equals("#분위기가 좋아요"));
	}
	
	public boolean isKind() {
		return reviewKeywords.stream().map(item -> item.getKeyword()).anyMatch(item -> item.equals("#친절해요"));
	}

}
