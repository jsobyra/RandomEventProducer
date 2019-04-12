import java.time.LocalDate;

public class RandomEvent {
    private final String productName;
    private final Double productPrice;
    private final LocalDate purchaseDate;
    private final String productCategory;
    private final String ipAddress;

    public RandomEvent(String productName, Double productPrice, LocalDate purchaseDate,
                       String productCategory, String ipAddress) {
        this.productCategory = productCategory;
        this.ipAddress = ipAddress;
        this.productName = productName;
        this.productPrice = productPrice;
        this.purchaseDate = purchaseDate;
    }


    @Override
    public String toString() {
        return productName +
                "," + productPrice.toString() +
                "," + productCategory +
                "," + ipAddress +
                "," + purchaseDate.toString();
    }
}
