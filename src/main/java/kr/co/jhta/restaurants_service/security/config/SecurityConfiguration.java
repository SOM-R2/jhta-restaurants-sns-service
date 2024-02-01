package kr.co.jhta.restaurants_service.security.config;

import kr.co.jhta.restaurants_service.controller.*;
import kr.co.jhta.restaurants_service.controller.users.CustomerController;
import kr.co.jhta.restaurants_service.controller.users.OwnerController;
import kr.co.jhta.restaurants_service.controller.users.UserController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true, securedEnabled = true)
@Configuration
public class SecurityConfiguration {

    @Autowired
    private AuthenticationFailureHandler authenticationFailureHandler;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        return http
                .csrf().disable()

                .authorizeRequests(urlRegistry -> {

                    // further authorization specification needed
                    urlRegistry.antMatchers(CustomerController.PUBLIC_URLS).permitAll();
                    urlRegistry.antMatchers("/customer/**").authenticated();

                    urlRegistry.antMatchers(OwnerController.PUBLIC_URLS).permitAll();
                    urlRegistry.antMatchers("/owner/**").authenticated();

                    urlRegistry.antMatchers(UserController.PUBLIC_URLS).permitAll();
                    urlRegistry.antMatchers("/user/**").authenticated();

                    urlRegistry.antMatchers(StoreController.PUBLIC_URLS).permitAll();
                    urlRegistry.antMatchers("/store/**").authenticated();

                    urlRegistry.antMatchers("/like/**").authenticated();

                    urlRegistry.antMatchers(ReviewController.PUBLIC_URLS).permitAll();
                    urlRegistry.antMatchers("/review/**").authenticated();

                    urlRegistry.antMatchers(PostController.PUBLIC_URLS).permitAll();
                    urlRegistry.antMatchers("/post/**").authenticated();

                   // urlRegistry.antMatchers(ImageController.PUBLIC_URLS).permitAll();
                    urlRegistry.antMatchers("/images/**").authenticated();

                    urlRegistry.antMatchers(HomeController.PUBLIC_URLS).permitAll();
                    urlRegistry.antMatchers("/feed").authenticated();

                    urlRegistry.antMatchers("/bookmark/**").authenticated();

                    urlRegistry.anyRequest().permitAll();
                })

                .formLogin(config -> {
                    config.loginPage("/user/login");
                    config.usernameParameter("username");
                    config.passwordParameter("password");
                    config.loginProcessingUrl("/user/login");
                    config.defaultSuccessUrl("/");
//                    config.failureUrl("/user/login?error=fail");
                    config.failureHandler(authenticationFailureHandler);
                })

                .logout(config -> {
                    config.logoutUrl("/user/logout");
                    config.logoutSuccessUrl("/");
                    config.invalidateHttpSession(true);
                })

                .exceptionHandling(config -> {
                    config.authenticationEntryPoint(((request, response, authException) -> {
                        response.sendRedirect("/user/login?error=anonymous");
                    }));
                    config.accessDeniedHandler(((request, response, accessDeniedException) -> {
                        response.sendRedirect("/user/login?error=denied");
                    }));
                })

                .build();
    }

    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
