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
@Table(name = "offer")
public class Offer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int offerId;
    @Column
    private int bidderId;
    @Column
    private int offer;
    @Column
    private int auctionId;

}
