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
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "descendingpriceauction")

public class DescendingPriceAuction extends Auction{

    @Column(nullable = false)
    private long startingPrice;
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'")
    @Column(nullable = false)
    private LocalDateTime startingDate;
    @Column(nullable = false)
    private int timer = 10;
    @Column(nullable = false)
    private int timerAmount = 10;
    @Column(nullable = false)
    private long reduction;
    @Column(nullable = false)
    private int minimumPrice;
}
