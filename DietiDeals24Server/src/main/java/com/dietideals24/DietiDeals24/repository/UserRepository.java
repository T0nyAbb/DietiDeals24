package com.dietideals24.DietiDeals24.repository;

import com.dietideals24.DietiDeals24.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    User getUserById (Long id);

    Optional<User> findByUsername(String email);
}
