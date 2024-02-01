package kr.co.jhta.restaurants_service.vo.inquiry;


import org.apache.ibatis.type.Alias;

// import com.google.cloud.Date;

import kr.co.jhta.restaurants_service.vo.user.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
@Alias("Inquiry")
public class Inquiry {

	private int id;
	private String title;
	private String content;
	private User user;
	private int readCount;
	private int reviewCount;
//	private Date createDate;
	private String disabled;
	
	@Builder
	public Inquiry(int id, String title, String content, User user, int readcount,
				   int reviewCount, String disabled) {
		super();
		this.id = id;
		this.title = title;
		this.content = content;
		this.user=user;
		this.readCount = readcount;
		this.reviewCount= reviewCount;
//		this.createDate =  createDate;
		this.disabled = disabled;
	}
	
	// 이전 코드
//	@Builder
//	public Inquiry(int id, String title, String content, User user, int readcount,
//			int reviewCount, Date createDate, String disabled) {
//		super();
//		this.id = id;
//		this.title = title;
//		this.content = content;
//		this.user=user;
//		this.readCount = readcount;
//		this.reviewCount= reviewCount;
//		this.createDate =  createDate;
//		this.disabled = disabled;
//	}
	
	
}
