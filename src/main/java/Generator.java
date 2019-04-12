import java.time.LocalDate;
import java.util.Random;
import java.util.concurrent.atomic.AtomicLong;

public class Generator {
    private final Random random;
    private final AtomicLong counter;

    public Generator() {
        this.random = new Random();
        this.counter = new AtomicLong();
    }

    public RandomEvent generateRandomEvent() {
        Long id = counter.incrementAndGet() % (random.nextInt(10000) + 1);
        String productName = "productName" + id;
        Double productPrice = 2 * random.nextGaussian() + 2;
        LocalDate purchaseDate = LocalDate.of(2019, 10, random.nextInt(6) + 1);
        String productCategory = "productCategory" + id / 10;
        String ipAddress = random.nextInt(256) + "." + random.nextInt(256)
                + "." + random.nextInt(256) + "." + random.nextInt(256);
        return new RandomEvent(productName, productPrice, purchaseDate, productCategory, ipAddress);
    }
}