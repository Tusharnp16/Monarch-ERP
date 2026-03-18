package com.monarch.monarcherp.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonView;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.ParamDef;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

@MappedSuperclass
@Getter @Setter
@FilterDef(name = "tenantFilter", parameters = @ParamDef(name = "userId", type = Long.class))
// {alias} ensures Hibernate adds the filter to the correct table during joins
@Filter(name = "tenantFilter", condition = "user_id = :userId")
public abstract class AbstractStoreEntity {
    @JsonIgnore // Prevent the LazyLoading/Proxy error we saw earlier
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;



    @PrePersist
    public void handleBeforeSave() {
        if (this.user == null) {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated()) {
                Object principal = auth.getPrincipal();
                if (principal instanceof User currentUser) {
                    this.user = currentUser;
                }
                // Fallback: if principal is a string or different object,
                // you might need a small helper to fetch the User entity.
            }
        }
    }


}
