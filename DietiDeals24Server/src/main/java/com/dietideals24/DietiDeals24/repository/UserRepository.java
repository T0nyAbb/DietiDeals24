package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
}
