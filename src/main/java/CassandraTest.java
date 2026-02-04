import io.javalin.Javalin;
import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.cql.Row;
import java.net.InetSocketAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class CassandraTest {
    public static void main(String[] args) {
        
        System.out.println("Starting API and connecting to Cassandra...");

        try {
            // 1. Initialize Session
            CqlSession session = CqlSession.builder()
                    .addContactPoint(new InetSocketAddress("192.168.56.105", 30042))
                    .withLocalDatacenter("datacenter1")
                    .withKeyspace("inventory")
                    .build();

            // 2. Setup Javalin
            Javalin app = Javalin.create(config -> {
                config.bundledPlugins.enableDevLogging(); // Prints every request to console
            }).start(8080);

            // 3. Global Error Tracker (Forces errors to show in terminal)
            app.exception(Exception.class, (e, ctx) -> {
                System.err.println("CRASH DETECTED: " + e.getMessage());
                e.printStackTrace(); // This is what we need to see!
                ctx.status(500).result("Real Error: " + e.getMessage());
            });

            // 4. The Route
app.get("/inventory", ctx -> {
    try {
        System.out.println("Querying Cassandra...");
        var results = new ArrayList<Map<String, Object>>();
        var rs = session.execute("SELECT item_name, item_price, item_stock_avlb FROM items");
        
for (Row row : rs) {
    System.out.println("--- Processing a row ---");
    Map<String, Object> item = new HashMap<>();
    
    try {
        String name = row.getString("item_name");
        System.out.println("Got name: " + name);
        item.put("name", name);

        // This is the most likely spot for the 500
        java.math.BigDecimal price = row.getBigDecimal("item_price");
        System.out.println("Got price: " + price);
        item.put("price", price != null ? price.doubleValue() : 0.0);

        int stock = row.getInt("item_stock_avlb");
        System.out.println("Got stock: " + stock);
        item.put("stock", stock);
        
        results.add(item);
    } catch (Exception rowEx) {
        System.err.println("Failed while reading a specific column: " + rowEx.getMessage());
        throw rowEx; // Send it to the main catch
    }
}
        // Replace ctx.json(results) with this:
StringBuilder manualJson = new StringBuilder("[");
for (int i = 0; i < results.size(); i++) {
    manualJson.append(String.format("{\"name\":\"%s\", \"price\":%s, \"stock\":%d}", 
        results.get(i).get("name"), 
        results.get(i).get("price"), 
        results.get(i).get("stock")));
    if (i < results.size() - 1) manualJson.append(",");
}
manualJson.append("]");

ctx.contentType("application/json").result(manualJson.toString());


        System.out.println("Success: Sent " + results.size() + " items.");
    } catch (Exception e) {
        // THIS WILL SHOW US THE ACTUAL ERROR IN YOUR TERMINAL
        System.err.println("--- API ERROR DETECTED ---");
        e.printStackTrace(); 
        ctx.status(500).result("Error: " + e.toString());
    }
});
        } catch (Exception e) {
            System.err.println("FAILED TO START SERVER:");
            e.printStackTrace();
        }
    }
}