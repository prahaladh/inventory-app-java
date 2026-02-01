package com.example.inventory.model;

import org.springframework.data.cassandra.core.mapping.PrimaryKey;
import org.springframework.data.cassandra.core.mapping.Table;
import lombok.Data;

@Table("inventory")
@Data
public class InventoryItem {
    @PrimaryKey
    private String item_name;
    private double item_price;
    private int item_stock_avlb;
}
