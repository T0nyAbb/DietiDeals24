package com.dietideals24.DietiDeals24.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "inverseauction")

public class InverseAuction {

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
    @Column
    private int startingPrice;
    @Column
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern = "dd-MM-yyyy'T'HH:mm:ss[.SSS][.SS][.S]")
    private LocalDateTime expiryDate;
    @Column
    private String bidder;
}
