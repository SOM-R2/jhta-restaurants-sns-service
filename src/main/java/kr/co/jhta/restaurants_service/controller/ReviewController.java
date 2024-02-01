package kr.co.jhta.restaurants_service.controller;

import java.io.IOException;


import java.util.List;
import java.util.Optional;
import java.util.UUID;

import kr.co.jhta.restaurants_service.vo.review.ReviewPicture;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

//import com.google.cloud.storage.Blob;
//import com.google.cloud.storage.BlobId;
//import com.google.cloud.storage.BlobInfo;
//import com.google.cloud.storage.Storage;

import kr.co.jhta.restaurants_service.controller.command.ReviewCommentCommand;
import kr.co.jhta.restaurants_service.controller.command.ReviewReportCommand;
import kr.co.jhta.restaurants_service.controller.command.ReviewCommand;
import kr.co.jhta.restaurants_service.dto.ReviewContentsDto;
import kr.co.jhta.restaurants_service.dto.ReviewDetailDto;
import kr.co.jhta.restaurants_service.security.domain.SecurityUser;
import kr.co.jhta.restaurants_service.service.ReviewService;
import kr.co.jhta.restaurants_service.service.StoreService;
//import kr.co.jhta.restaurants_service.dto.ReviewListDto;
import kr.co.jhta.restaurants_service.vo.review.ReviewKeyword;
import kr.co.jhta.restaurants_service.vo.store.Store;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/review")
@Slf4j
public class ReviewController {
	
	
	private final ReviewService reviewService;
	
	private final StoreService storeService;
	
//	private final Storage storage;

	public static String[] PUBLIC_URLS = {
			"/review/detail",
			"/review/allReviews",
			"/review/get/allReview",
			"/review/get/keywords"
	};

	// 리뷰 등록화면
	@PreAuthorize("isAuthenticated()")
	@GetMapping
	public String review(Model model, @RequestParam("storeId") int storeId ) {
		
		Store store = storeService.getStoreById(storeId);
		model.addAttribute("store", store);
		
		return "review";
	}
	
	// 리뷰 등록 요청 처리
	@PostMapping
	public String reviewRegister(ReviewCommand form, @AuthenticationPrincipal SecurityUser securityUser) throws IOException {

		int idx = 0;
		List<String> uuidPrefixedFileNames = reviewService.createReview(form, securityUser);

//		try {
//			String bucketName = "jhta-restaurants-sns-service";
//			for(MultipartFile imageName : form.getChooseFile()) {
//				String objectName = "review/" + uuidPrefixedFileNames.get(idx);
//
//				BlobId blobId = BlobId.of(bucketName, objectName);
//				BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType(imageName.getContentType()).build();
//
//				Blob blob = storage.create(blobInfo, imageName.getBytes());
//
//				idx += 1;
//			}
//
//		} catch (IOException e) {
//			e.printStackTrace();
//		}

		return "redirect:/store/detail?id=" + form.getStoreId();
	}
	// 리뷰 답글 등록 요청 처리
		@PostMapping("/store/register")
		public String reviewCommentStoreRegister(int storeId, ReviewCommentCommand form, @AuthenticationPrincipal SecurityUser securityUser) {
			reviewService.createReviewComment(form, securityUser);
			
			return "redirect:/store/detail?id=" + storeId;
		}
		
		// 리뷰 답글 등록 요청 처리
		@PreAuthorize("isAuthenticated()")
		@PostMapping("/register")
		public String reviewCommentRegister(int storeId, ReviewCommentCommand form, @AuthenticationPrincipal SecurityUser securityUser) {
			reviewService.createReviewComment(form, securityUser);
			
			return "redirect:/review/detail?id=" + form.getReviewId();
		}

	
		
	@GetMapping("/detail")
	public String reviewDetail(Model model, @RequestParam("id") int reviewId) {
		 
		ReviewDetailDto dto = reviewService.selectReview(reviewId);
		model.addAttribute("review", dto);
		
		return "reviewDetail";
	}
	
	@GetMapping("/del")
	public String deleteReview(@RequestParam("storeId") int storeId,
			@RequestParam("reviewId") int reviewId) {

		reviewService.deletedReview(reviewId);
		
		return "redirect:/store/detail?id=" + storeId;
		
	}
	
	@GetMapping("store/comment/del")
	public String deleteReviewStoreComment(@RequestParam("storeId") int storeId, 
			@RequestParam("reviewId") int reviewId, @RequestParam("reviewCommentId") int reviewCommentId) {
		
		reviewService.deletedReviewComment(reviewCommentId);
		
		return "redirect:/store/detail?id=" + storeId;
	}
	
	@GetMapping("/comment/del")
	public String deleteReviewComment(@RequestParam("reviewId") int reviewId, @RequestParam("reviewCommentId") int reviewCommentId) {
		
		reviewService.deletedReviewComment(reviewCommentId);
		
		return "redirect:/review/detail?id=" + reviewId;
	}
	
	@PostMapping("/reviewReport")
	@ResponseBody
	public ResponseEntity<String> reviewReportRegister(ReviewReportCommand form, @AuthenticationPrincipal SecurityUser securityUser) {
	    reviewService.createReviewReport(form, securityUser);
	    log.info("신고 -> {}", form.getCategory());
	    return ResponseEntity.ok().body("/detail?id=" + form.getReviewId()); // 리디렉션 경로 반환
	}
	
	@GetMapping("/allReviews")
	public String AllReivews(Model model) {
		return "allReview";
	}
	
	@GetMapping("/followerReviews")
	public String followerReview(){
		
		return "followerReview";
	}
	
	/*
	 * @GetMapping("/review") public String reviewPage(@RequestParam("storeId") int
	 * storeId, Model model) { Store store = storeService.getStoreById(storeId);
	 * model.addAttribute("store", store);
	 * 
	 * // 모델에 다른 필요한 정보도 추가할 수 있음
	 * 
	 * return "review"; // 리뷰 페이지로 이동 }
	 */
	@ResponseBody
    @GetMapping("/get/allReview")
    public List<ReviewContentsDto> getAllReviews(@RequestParam("page") Integer page,
                                   @RequestParam("limit") Integer limit) {

        return reviewService.getAllReviewsPaginated(page, limit);
    }
	
	@ResponseBody
    @GetMapping("/get/followerReview")
    public List<ReviewContentsDto> getFollowerReviews(@RequestParam("page") Integer page,
                                   @RequestParam("limit") Integer limit,
                                   @AuthenticationPrincipal SecurityUser securityUser) {

        return reviewService.getFollowerReviewsPaginated(page, limit, securityUser);
    }
	
	@ResponseBody
	@GetMapping("/get/keywords")
	public List<ReviewKeyword> getReviewsKeywords(@RequestParam("reviewId") Integer reviewId){
		return reviewService.getReviewKeywords(reviewId);
	}

	@ResponseBody
	@GetMapping("/keywords-by-user")
	public List<String> reviewKeywordsByUser(@AuthenticationPrincipal SecurityUser securityUser,
											 @RequestParam("id") Optional<Integer> userId) {
		return reviewService.getReviewKeywordsByUserId(userId.orElse(securityUser.getUser().getId()), 4);
	}

}
