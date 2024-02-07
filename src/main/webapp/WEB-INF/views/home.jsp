<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>   
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
  
<!DOCTYPE html>
<html lang="ko">
<head>
	<link rel="shortcut icon" href="/images/logo/png/favicon.ico"image/x-icon">
	<link rel="icon" href="/images/logo/png/favicon.ico" type="image/x-icon">
    <title>Food Street</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">   
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    
    <style type="text/css">
		.card-text {
			white-space: normal;
			overflow: hidden;
			text-overflow: ellipsis;
			display: -webkit-box;
					 -webkit-line-clamp: 3;
					 -webkit-box-orient: vertical;
		}
	</style>
</head>
<body>
<%@ include file="common/navbar.jsp"%>
<div class="wrap">
	<div class="container-fluid">
		<div class= "row d-flex justify-content-between mt-3">
			<div class="col-2 ps-0">
	            <nav id="home-left-navbar " class="h-100 flex-column align-items-stretch pe-4 border-end bg-light" >
	                <nav class="nav nav-pills flex-column fw-lighter ps-3 pt-4" style="position:sticky; top: 60px;">
                        <sec:authorize access="isAuthenticated()">
	                    	<sec:authorize access="hasRole('ROLE_OWNER')">
		                    	<a class="nav-link my-3 ms-2 link-dark" href="/owner/my-page"><i class="bi bi-person-circle fs-5 me-3"></i>마이페이지</a>
		                	</sec:authorize>
	                    	<sec:authorize access="hasRole('ROLE_CUSTOMER')">
		                    	<a class="nav-link my-3 ms-2 link-dark" href="/customer/my-page"><i class="bi bi-person-circle fs-5 me-3"></i>마이페이지</a>
		                    	
		                    	<a class="nav-link my-3 ms-2 link-dark" href="/post/register"><i class="bi bi-plus-square fs-5 me-3"></i>새 포스트</a>
		                	</sec:authorize>
	                        <a class="nav-link my-3 ms-2 link-dark" href="/contents"><i class="bi bi-card-text fs-5 me-3"></i>컨텐츠</a>
	                        <a class="nav-link my-3 ms-2 link-dark" href="/user/logout"><i class="bi bi-box-arrow-right fs-5 me-3"></i>로그아웃</a>
	                    </sec:authorize>
	                    <sec:authorize access="isAnonymous()">
    			           	<a class="nav-link my-3 ms-2 link-dark" href="/user/login"><i class="bi bi-power me-3 fs-5"></i>로그인</a>  
    			           	<a class="nav-link my-3 ms-2 link-dark" id="signupPopover-side" class="btn btn-secondary" 
    			           	   tabindex="0" data-bs-container="body" data-bs-toggle="popover" data-bs-placement="right"
    			           	   data-bs-html="true" data-bs-trigger="focus" data-bs-content="
	                           <div class='fw-light'>
	                               <div class='row text-center mx-1'>
	                                   <a class='link-dark text-center link-underline-opacity-0 py-2' href='/customer/signup'>손님 회원가입</a>
	                               </div>
	                               <div class='row text-center mx-1'>
	                                   <a class='link-dark text-center link-underline-opacity-0 py-2' href='/owner/signup'>사장님 회원가입</a>
	                               </div>
	                           </div>
                           " style="cursor:pointer;"><i class="bi bi-person-plus me-3 fs-5"></i>회원가입</a>
	                        <a class="nav-link my-3 ms-2 link-dark" href="/contents"><i class="bi bi-card-text fs-5 me-3"></i>컨텐츠</a>
	                    </sec:authorize>
	                </nav>
	            </nav>
			</div>

			<script>new bootstrap.Popover(document.querySelector('#signupPopover-side'))</script>
			
			<div class="col-4 mb-3 me-3 pt-5" id="home-content"></div>
			<div class="col-3 pt-5 home-side-contents" >
				<h4 class="mb-4" style="color:#ff792a;">인기  포스트</h4>
				<c:forEach var="post" items="${postList}">
					<div class="card mb-3" style="border: none; cursor: pointer;" onclick="location.href='/post/detail?id=${post.id}'">
						<div class="row d-flex justify-content-start">
							<div class="col-7" style="display:block; overflow:hidden; white-space:nowrap; text-overflow:epllipsis;">
								<p>${post.title}</p>
								<p class="text-secondary" >${post.subTitle}</p>
							</div>
							<div class="col-3">
								<img src="/images/post/png/${post.pictureFile}" onerror="this.onerror=null; this.src='/images/review/jpeg/default.jpeg';" class="img-fluid rounded-end" alt="..." style="object-fit: cover; width:100px; height:80px;">
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<%@ include file="common/footer.jsp" %>
</div>

<script type="text/javascript">
// 	document.getElementById("form-navbar-search").style.display = "none";
	
	let pageOnFeed = 1;
    let isFeedsFetching = false;
	let isFeedsLast = false;
	
	//로그인 확인
	var isLogin;
	isLogin = ${pageContext.request.userPrincipal != null} ? true : false;
	getFeed();
	
	// 검색 키워드 예외처리
	$("#form-search-keyword").submit(function(event) {
		let keyword = $("#field-keyword").val();
		if (!keyword.trim()) {
			$("#field-keyword").val("");
			alert("검색어를 입력하세요");
			//return false : 폼 제출 취소
			return false;
		}
		return true;
	})
	
	//Click Listener - bookmark star 
	$("#home-content").on('click', '[id^="star-"]', function(){
			//로그인 했을 때
    	if (isLogin) {
    	let storeId = $(this).attr('store-id');
		console.log("storeId :" , storeId);
		//star- fill -> blank
		if ($(this).hasClass('bi-star-fill')) {
				$(this).removeClass('bi-star-fill').addClass('bi-star')
				$.getJSON('/bookmark/delete', {storeId : storeId});
		//star- blank -> fill		
		} else {
			$(this).removeClass('bi-star').addClass('bi-star-fill')
			$.getJSON('/bookmark/insert', {storeId : storeId});
			}
	    } else {
	       // 로그인되지 않은 경우, 로그인 페이지 열기
	       	alert("로그인이 필요합니다");
	        window.location.href = "/user/login?error=anonymous";
	    }
	});
	
	//Click Listener - Review Like 
	$("#home-content").on('click', '[id^="like-"]', function(){
	    if (isLogin) {
	    	const $like = $(this);
			//로그인 했을 때
	    	let reviewId = $like.attr('data-reviewId');
			//like- fill -> blank
			if ($like.hasClass('bi-heart-fill')) {
					$like.removeClass('bi-heart-fill').addClass('bi-heart')
					$.getJSON('/like/delete', {reviewId : reviewId},function(result){
						$("span[data-reviewId=" + reviewId + "]").text(result);
					});
					
			//like- blank -> fill		
			} else {
				$like.removeClass('bi-heart').addClass('bi-heart-fill')
				$.getJSON('/like/insert', {reviewId : reviewId}, function(result){
					$("span[data-reviewId=" + reviewId + "]").text(result);
				});

			}
	    } else {
	       // 로그인되지 않은 경우, 로그인 페이지 열기
	       	alert("로그인이 필요합니다");
	        window.location.href = "/user/login?error=anonymous";
	    }
	});
	
	//Button Event Listener - Follow request
	$("#home-content").on('click', '[id^="button-follow-"]', function(){
		let  $btn = $(this);
	    if (isLogin) {
	    	if($(this).hasClass('active')){
	    		$(this).removeClass('active');
	    		$(this).text("팔로우");
	    		
	    	}else{//팔로우 요청 
				const writerId = $(this).attr('data-writer-id');
	    		console.log("before postJSON");
	    		
				$.post('/user/follow',{recipientId : writerId})
				 .done(function(){
					$btn.addClass("active");
					$btn.text("요청됨");
					$btn.prop('disabled',true);
				})
				 .fail(function() {
					 alert("이미 팔로우 요청되었습니다.");
				 })
				;
	    	}

	    } else {
	       // 로그인되지 않은 경우, 로그인 페이지 열기
	       	alert("로그인이 필요합니다");
	        window.location.href = "/user/login?error=anonymous";
	    }
	});
	
	function getFeed() {
		
		isFeedsFetching = true;
		const url = isLogin ? '/feed' : '/allfeed'; 
		
		$.getJSON(url ,{page : pageOnFeed, limit:5}, function(result) {
			
	        if (result.length < 5) {
	            isFeedsLast = true;
	        }
			result.forEach(function(feed){
				let followButton = '';
				if(feed.isFollowed ==='n'){
					followButton = `
						<button id="button-follow-\${feed.id}" class="btn btn-primary border-0 btn-sm" 
						 feed-id="\${feed.id}" data-writer-id="\${feed.userId}">팔로우</button>
					`;
				}
				let star = feed.isBookmarked==='y' ? 'bi-star-fill' : 'bi-star';
				let like = feed.isLiked==='y' ? 'bi-heart-fill' : 'bi-heart';
				
				let content = `
					<div id=home-content-header class="d-flex justify-content-between mb-2" >
						<div id="home-feed-writer">
							<img type="button" id="userImage-\%{feed.id}" src="/images/user/png/\${feed.username}" onclick="location.href='/user/details?id=\${feed.userId}'"
							 class="rounded-circle shadow-sm object-fit-cover mx-1" data-user-id="\${feed.userId}" 
							 onerror="this.onerror=null; this.src='/images/user/png/user-default-image.png';" alt="User Image" style="width: 40px; height: 40px;"/>
							
							 <span class="me-2 fw-bold" onclick="location.href='/user/details?id=\${feed.userId}'" style="cursor: pointer;">\${feed.username} </span>
							\${generateRating(feed.rating)}
							<span class="text-secondary ms-1" id="dateValue-\${feed.id }">\${timeForToday(feed.createDate)} </span]>
						</div>
						<div id="followButtonArea" class="d-flex align-items-center">
							\${followButton}
						</div>	
					</div>
					<div id="store-card" class="card mb-5" style="border: none;">
						<div id="carouselHomeFeedIndicators-\${feed.id}" class="carousel slide">
						  <div class="carousel-indicators" id="carousel-indicators-\${feed.id}">
						 	\${generateIndicator(feed.reviewPictures,feed)}
						  </div>
						  <div class="carousel-inner" id ="carousel-inner-\${feed.id}">
							\${generatePicture(feed.reviewPictures,feed)}
						  </div>
						  \${generateControlButton(feed.reviewPictures,feed)}
						</div>
						
						<div class="card-body pt-1 ps-1" >
							<p class="card-text mb-1" onclick="location.href='/review/detail?id=\${feed.reviewId}'" style="cursor: pointer;">\${feed.content}</p>
							<i class="bi \${like} fs-4" id="like-\${feed.id}" data-reviewId="\${feed.reviewId}" style="cursor: pointer; color: red;"></i> 
							<span class="text fs-6 fw-lighter" data-reviewId="\${feed.reviewId}">\${feed.likedCount}</span>
							<div class="border d-flex justify-content-between mt-2" >
								<div class="row" onclick="location.href='/store/detail?id=\${feed.storeId}'" style="cursor: pointer;">
									<div class="col ms-1">
							           <p class="mb-0"><strong>\${feed.storeName}</strong></p>	
							           <p class="text-secondary mb-0"><small>\${feed.address}</small></p>	
									</div>
								</div>
								<div class="d-flex align-items-center px-2">
									<i class="bi \${star} fs-4" id="star-\${feed.id}" store-id="\${feed.storeId}" style="cursor: pointer; color: gold;"></i>
								</div>
							</div>		
						</div>
					</div>
				`;
				$("#home-content").append(content);
				
				});
			});

		isFeedsFetching = false;
	}
	
	function generateRating(rating){
		let badge = ""
		if(rating==5){
			let content =  `<span class="badge bg-warning-subtle text-warning-emphasis rounded-pill">맛있어요!</span> `;
			badge += content;
			
		}else if(rating==3){
			let content =  `<span class="badge bg-warning-subtle text-warning-emphasis rounded-pill">괜찮아요</span> `;
			badge += content;

		}else if(rating==1){
			let content =  `<span class="badge bg-warning-subtle text-warning-emphasis rounded-pill">별로에요</span> `;
			badge += content;

		}else{
			return badge;
		}
		
		let content =  `<span class="badge rounded-pill" style="color: #ff792a; font-size:20px; ">맛있어요</span> `;
		return badge;
	}
	
	function generateIndicator(pictures,feed){
		let indicators = "";
		if(pictures.length<=1){
			return indicators;
		}
		pictures.forEach(function(picture, index) {
				if (index==0){
					let indicator = `
						<button type="button" data-bs-target="#carouselHomeFeedIndicators-\${feed.id}" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
					`
					indicators += indicator;
				}else{
					let indicator = `
					    <button type="button" data-bs-target="#carouselHomeFeedIndicators-\${feed.id}" data-bs-slide-to="\${index}" aria-label="Slide \${index}"></button>
					`
						indicators += indicator;
				}
		})
		return indicators;
	}
	
	function generatePicture(pictures,feed) {
		let images = "";
		pictures.forEach(function(picture, index) {
			
			let activeClass="";
			if(index==0){activeClass = "active";}
			
			let imgContent = `
			    <div class="carousel-item \${activeClass}">
			      <img src="/images/review/png/\${picture.pictureName}" class="card-img-top rounded " 
			      alt="..." style="object-fit: cover; height:400px; cursor: pointer;"
		    	  onclick="location.href='/review/detail?id=\${feed.reviewId}'">
			    </div>			
				`
			images += imgContent;
		})
		
		return images;
	}
	
	function generateControlButton(pictures,feed){
		let buttons=""
		
		if (pictures.length<=1){
			return buttons;
		}
		let button = `
		  <button class="carousel-control-prev" type="button" data-bs-target="#carouselHomeFeedIndicators-\${feed.id}" data-bs-slide="prev">
		    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Previous</span>
		  </button>
		  <button class="carousel-control-next" type="button" data-bs-target="#carouselHomeFeedIndicators-\${feed.id}" data-bs-slide="next">
		    <span class="carousel-control-next-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Next</span>
		  </button>
		`
		buttons+= button;
		return buttons;
	}
	
    window.onscroll = function () {
        if ((window.innerHeight + window.scrollY +10) >= document.body.offsetHeight) {

            if (isFeedsFetching || isFeedsLast) {
                // do nothing
            } else {
            	console.log("onScroll");
             	pageOnFeed += 1;
            	getFeed();        	    
            }
        }
    }
    
	function timeForToday(value) {
		console.log("timeforToday");
	    const today = new Date();
	    const timeValue = new Date(value);
	    const betweenTime = Math.floor((today.getTime() - timeValue.getTime()) / 1000 / 60);
	
	    if (betweenTime < 1) return '방금전';
	    if (betweenTime < 60) {
	        return `\${betweenTime}분전`;
	    }
	
	    const betweenTimeHour = Math.floor(betweenTime / 60);
	    if (betweenTimeHour < 24) {
	        return `\${betweenTimeHour}시간전`;
	    }
	
	    const betweenTimeDay = Math.floor(betweenTime / 60 / 24);
	    if (betweenTimeDay < 365) {
	        return `\${betweenTimeDay}일전`;
	    }
	
	    return `\${Math.floor(betweenTimeDay / 365)}년전`;
	}

</script>
</body>
</html>