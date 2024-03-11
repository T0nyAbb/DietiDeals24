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

    @Column
    private int timer;

    @Column
    private int reduction;

    @Column
    private int minimumPrice;
}
