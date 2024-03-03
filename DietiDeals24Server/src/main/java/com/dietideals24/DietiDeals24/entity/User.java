package com.dietideals24.DietiDeals24.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @Column
    private String firstName;
    @Column
    private String lastName;
    @Column(nullable = false, unique = true)
    private String email;
    @Column
    private String password;
    @Column
    private String bio;
    @Column
    private String sitoweb;
    @Column
    private String social;
    @Column
    private String Google;
    @Column
    private String Facebook;
    @Column
    private String Apple;
    @Column
    private String profilePicture;

}
