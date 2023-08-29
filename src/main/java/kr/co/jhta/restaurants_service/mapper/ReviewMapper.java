package kr.co.jhta.restaurants_service.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.co.jhta.restaurants_service.dto.ReviewDto;
import kr.co.jhta.restaurants_service.dto.ReviewSummaryDto;
import kr.co.jhta.restaurants_service.vo.review.Review;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ReviewMapper {

	void insertReview(Review review);
	Review getReviewById(int id);
	Review getReviewByCustomerId(int customerId);
	Review getReviewByStoreId(int storeId);
	List<Review> getAllReviewsByStoreId(int storeId);
	List<Review> getAllReviewsByCustomerId(int customerId);
	ReviewSummaryDto getAllReviewRatingByStoreId(int storeId);
	List<ReviewDto> getReviewsByStoreId(int storeId);
	List<ReviewDto> getReviewsPaginatedByStoreId(@Param("begin") int begin, @Param("end") int end, @Param("storeId") int storeId);
    List<ReviewDto> getReviewsPaginatedByStoreIdAndRating(@Param("begin") int begin,
														  @Param("end") int end,
														  @Param("storeId") int storeId,
														  @Param("rating") int rating);
}
