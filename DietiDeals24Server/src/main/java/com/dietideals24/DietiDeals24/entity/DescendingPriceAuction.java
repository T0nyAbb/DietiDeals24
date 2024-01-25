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
@Table(name = "descendingpriceauction")

public class DescendingPriceAuction extends Auction{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private int startingPrice;
    private int timer;
    private int reduction;
}
