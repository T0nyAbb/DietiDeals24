package com.dietideals24.DietiDeals24.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "fixedtimeauction")

public class FixedTimeAuction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    @Column
    private String title;
    @Column(nullable = true)
    private String description;
    @Column(nullable = true)
    private String category;
    @Column
    private long sellerId;
    @Column
    private String urlPicture;
    @JsonFormat(pattern = "dd-MM-yyyy HH:mm:ss")
    @Column
    private LocalDateTime expiryDate;
    @Column
    private int minimumPrice;
    @Column
    private String bidder;
}
