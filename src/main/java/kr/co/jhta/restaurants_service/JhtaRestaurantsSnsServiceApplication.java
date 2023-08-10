package kr.co.jhta.restaurants_service;

import com.fasterxml.jackson.databind.ObjectMapper;
import kr.co.jhta.restaurants_service.security.service.UserService;
import kr.co.jhta.restaurants_service.vo.user.Role;
import kr.co.jhta.restaurants_service.vo.user.User;
import org.jboss.logging.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Date;

@SpringBootApplication
public class JhtaRestaurantsSnsServiceApplication {

    Logger logger = Logger.getLogger(JhtaRestaurantsSnsServiceApplication.class);

    @Autowired
    private UserService userService;

    public static void main(String[] args) {
        SpringApplication.run(JhtaRestaurantsSnsServiceApplication.class, args);
    }

    @Bean
    public CommandLineRunner userJsonExample() {
        return args -> {

            UserDetails user = userService.loadUserByUsername("simon");

            ObjectMapper objectMapper = new ObjectMapper();
            String userJson = objectMapper.writeValueAsString(user);

            logger.info(userJson);
        };
    }

}
