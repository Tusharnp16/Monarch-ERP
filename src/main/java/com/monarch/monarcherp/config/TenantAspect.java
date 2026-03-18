package com.monarch.monarcherp.config;

import com.monarch.monarcherp.model.AbstractStoreEntity;
import com.monarch.monarcherp.model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
//
//@Aspect
//@Component
//public class TenantAspect {
//
//    @PersistenceContext
//    private EntityManager entityManager;
//
//    @Autowired
//    private com.monarch.monarcherp.repository.UserRepository userRepository;
//
//    @Before("execution(* com.monarch.monarcherp.service.*Service.*(..)) " +
//            "&& !execution(* com.monarch.monarcherp.service.RedisBlacklistService.*(..))")
//    @Transactional
//    public void beforeExecution() {
//        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
//
//        if (auth != null && auth.isAuthenticated()) {
//            String username = auth.getName(); // Works regardless of Principal type
//
//            // Fetch the user from DB to get the actual ID
//            userRepository.findByUserName(username).ifPresent(user -> {
//                Long currentUserId = user.getUserId();
//
//                if (currentUserId != null && currentUserId > 5) {
//                    Session session = entityManager.unwrap(Session.class);
//                    // Explicitly enable for the current session
//                    session.enableFilter("tenantFilter").setParameter("userId", currentUserId);
//                    System.out.println("LOG: Tenant Filter enabled for UserID: " + currentUserId);
//                }
//            });
//        }
//    }
//
//}

@Aspect
@Component
public class TenantAspect {

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private com.monarch.monarcherp.repository.UserRepository userRepository;

    @Before("execution(* com.monarch.monarcherp.service.*Service.*(..)) " +
            "&& !execution(* com.monarch.monarcherp.service.RedisBlacklistService.*(..))")
    @Transactional
    public void beforeExecution(JoinPoint joinPoint) { // Added JoinPoint
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null && auth.isAuthenticated()) {
            String username = auth.getName();

            userRepository.findByUserName(username).ifPresent(user -> {
                Long currentUserId = user.getUserId();

                // 1. Enable Filter for Reading
                if (currentUserId > 5) {
                    Session session = entityManager.unwrap(Session.class);
                    session.enableFilter("tenantFilter").setParameter("userId", currentUserId);
                }

                // 2. Inject User for Writing (The Fix for the NULL issue)
                Object[] args = joinPoint.getArgs();
                for (Object arg : args) {
                    if (arg instanceof AbstractStoreEntity entity) {
                        if (entity.getUser() == null) {
                            entity.setUser(user);
                            System.out.println("LOG: Injected UserID " + currentUserId + " into entity.");
                        }
                    }
                }
            });
        }
    }
}