package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    boolean existsByEmailAndPassword(String email, String password);
}
