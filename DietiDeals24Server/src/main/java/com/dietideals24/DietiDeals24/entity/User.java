package com.dietideals24.DietiDeals24.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "users")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @Column
    private String firstName;
    @Column
    private String lastName;
    @Column(nullable = false, unique = true)
    private String username;
    @Column
    private String password;
    @Column
    private String bio;
    @Column
    private String website;
    @Column
    private String social;  
    @Column
    private String google;
    @Column
    private String facebook;
    @Column
    private String apple;
    @Column
    private String profilePicture;
    @Enumerated(value = EnumType.STRING)
    private Role role;

    //Attributi aggiuntivi account venditore

    @Column
    private String iban;
    @Column
    private String altro; //DA AGGIUNGERE IL RESTO

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(role.name()));
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
