package com.dietideals24.DietiDeals24.entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "offer")
public class Offer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long offerId;
    @Column (nullable = false)
    private long bidderId;
    @Column (nullable = false)
    private int offer;
    @Column (nullable = false)
    private long auctionId;

    //Tipo di asta
    @Enumerated(value = EnumType.STRING)
    private Type type;

}
