package kr.co.jhta.restaurants_service.repository;

import kr.co.jhta.restaurants_service.projection.Projection;
import kr.co.jhta.restaurants_service.vo.review.Review;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewRepository extends JpaRepository<Review, Integer> {

    Page<Projection.Review> findReviewsByCustomerIdAndBlockedOrderByCreateDate(
            int customerId, Review.BLOCKED blocked, Pageable pageable
    );

}