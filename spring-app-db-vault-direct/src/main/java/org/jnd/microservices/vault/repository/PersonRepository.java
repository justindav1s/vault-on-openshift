package org.jnd.microservices.vault.repository;

import org.jnd.microservices.vault.model.Person;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.Repository;

public interface PersonRepository extends Repository<Person, Long> {

    Page<Person> findAll(Pageable pageable);

}
