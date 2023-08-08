package kr.co.jhta.restaurants_service.vo.store;

import java.util.Date;

import kr.co.jhta.restaurants_service.vo.user.User;
import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;

@Getter @Setter
@Alias("Store")
public class Store {

    @Id
    private int id;
    private String name;
    private String category;
    private String businessLicense;
    private String address;
    private int zipcode;
    private double latitude;
    private double longitude;
    private String description;
    private String phone;
    private int readCount;
    private Date createDate;
    private Date updateDate;
    private DISABLED disabled;
    private User owner;

    public Store() {

        this.createDate = new Date(); // default to current time
        this.updateDate = new Date(); // default to current time
        this.disabled = DISABLED.NO; // default to `NO`
    }

//    public Store(String category) {
//        if (CATEGORY.valueOf(category) != null) {
//            // String
//            this.category = CATEGORY.ASIAN.name();
//        }
//    }

    public enum DISABLED {
        YES, NO
    }

//    public enum CATEGORY {
//        KOREAN, JAPANESE, CHINESE, ASIAN, WESTERN, FASTFOOD, SNACK, DESSERT, CHICKEN, PIZZA, BAR, ITALIAN
//    }
}