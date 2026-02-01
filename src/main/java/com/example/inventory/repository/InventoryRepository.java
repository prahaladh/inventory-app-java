package com.example.inventory.repository;

import com.example.inventory.model.InventoryItem;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InventoryRepository extends CassandraRepository<InventoryItem, String> {
}
