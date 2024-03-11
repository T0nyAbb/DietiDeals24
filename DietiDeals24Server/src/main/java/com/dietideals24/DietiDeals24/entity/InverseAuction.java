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

public class InverseAuction extends Auction{

    @Column(nullable = false)
    private int startingPrice;

    @Column(nullable = false)
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern = "dd-MM-yyyy'T'HH:mm:ss[.SSS][.SS][.S]")
    private LocalDateTime expiryDate;
}
