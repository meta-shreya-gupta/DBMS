import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

class Order{
    private int order_Id;
    private String order_Date;
    private double order_Total;
    public Order(int order_Id , String order_Date , double order_Total){
        this.order_Id = order_Id;
        this.order_Date = order_Date;
        this.order_Total = order_Total;
    }
    public int getOrderId(){
        return order_Id;
    }
    public String getOrderDate(){
        return order_Date;
    }
    public double getOrderTotal(){
        return order_Total;
    }
    @Override
    public String toString(){
        return String.format("ID = %d , Date = %s , Total = %.2f" , order_Id , order_Date , order_Total);
    }
}

class ProductImage{
    private int productId;
    private String imageUrl;
    public ProductImage(int productId , String imageUrl){
        this.productId = productId;
        this.imageUrl = imageUrl;
    }
    public int getProductId(){
        return productId;
    }
    public String getImageUrl(){
        return imageUrl;
    }
    @Override
    public String toString(){
        return String.format("Product_Id = %d , URL =%s" , productId , imageUrl);
    }
}
class CategoryWithChildCount{
    private String catTitle;
    private int childCount;
    public CategoryWithChildCount(String catTitle , int childCount){
        this.catTitle = catTitle;
        this.childCount = childCount;
    }
    public String getCategoryTitle(){
        return catTitle;
    }
    public int getChildCount(){
        return childCount;
    }
    @Override
    public String toString(){
        return String.format("Cat_Title = %s , Cildren = %d" , catTitle , childCount);
    }
}

public class Assignment {
    private static final String host = "jdbc:mysql://localhost:3306/";
    private static final String dbName = "StoreFront2";
    private static final String mysqlURL = host + dbName;
    private static final String user = "root";
    private static final String password = "root";

    public static List<Order> getShippedOrder(int userId){
        List<Order> orders = new ArrayList<>();
        String query = "SELECT Orders.Order_Id , Orders.Order_Date , SUM(Order_Item.Price * Order_Item.Quantity) AS Order_Total FROM Orders JOIN Order_Item ON Orders.Order_Id = Order_Item.Order_Id WHERE Orders.User_Id = ? AND Order_Item.Status = 'SHIPPED' GROUP BY Orders.Order_Date , Orders.Order_Id ORDER BY Orders.Order_Date ASC";
        try(Connection connection = DriverManager.getConnection(mysqlURL , user , password);
        PreparedStatement preparedStatement1 = connection.prepareStatement(query);){
            preparedStatement1.setInt(1,userId);
            ResultSet rs= preparedStatement1.executeQuery();
            while(rs.next()) {
                int orderId = rs.getInt("Order_Id");
                String orderDate = rs.getString("Order_Date");
                double orderTotal = rs.getDouble("Order_Total");
                orders.add(new Order(orderId , orderDate , orderTotal));
            }
        }
        catch(SQLException e){
            e.printStackTrace();
        }
        return orders;
    }
    public static int[] insertImages(List<ProductImage> images){
        String query = "INSERT INTO Images(Prod_Id , Image_Url) VALUES (? , ?)";
        try(Connection connection = DriverManager.getConnection(mysqlURL , user , password);
        PreparedStatement preparedStatement2 = connection.prepareStatement(query)){
            for(ProductImage image : images){
                preparedStatement2.setInt(1 , image.getProductId());
                preparedStatement2.setString(2 , image.getImageUrl());
                preparedStatement2.addBatch();
            }
        return preparedStatement2.executeBatch();
        }catch(SQLException e){
            e.printStackTrace();
            return new int[0];
        }
    }
    public static int deleteProducts(){
        String query = "DELETE FROM Product WHERE Prod_Id NOT IN (SELECT DISTINCT Order_Item.Prod_Id FROM Order_Item JOIN Orders ON Order_Item.Order_Id = Orders.Order_Id WHERE Orders.Order_Date >= NOW() - INTERVAL 1 YEAR)";
        try(Connection connection = DriverManager.getConnection(mysqlURL , user , password);
        PreparedStatement preparedStatement3 = connection.prepareStatement(query);){
            return preparedStatement3.executeUpdate(query);
        }catch(SQLException e){
            e.printStackTrace();
            return 0;
        }
    }
    public static List<CategoryWithChildCount> getTopParentCategory(){
        List<CategoryWithChildCount> categories = new ArrayList<>();
        String query = "SELECT c1.Cat_Title , COUNT(c2.Cat_Id) AS Child_Count FROM Category c1 LEFT JOIN Category c2 ON c1.Cat_Id = c2.Parent_Category WHERE c1.Parent_Category IS NULL GROUP BY c1.Cat_Id , c1.Cat_Title ORDER BY c1.Cat_Title ASC";
        try(Connection connection = DriverManager.getConnection(mysqlURL, user, password);
        PreparedStatement preparedStatement4 = connection.prepareStatement(query);
        ResultSet rs = preparedStatement4.executeQuery(query);){
            while(rs.next()){
                String Cat_Title = rs.getString("Cat_Title");
                int count = rs.getInt("Child_Count");
                categories.add(new CategoryWithChildCount(Cat_Title, count));
            }
        }catch(SQLException e){
            e.printStackTrace();
        }
        return categories;
    }
    public static void main(String[] args) throws SQLException {
        List<Order> orders = getShippedOrder(4);
        System.out.println("Shipped orders for user 4");
        orders.forEach(System.out::println);

        List<ProductImage> images = new ArrayList<>();
        images.add(new ProductImage(1, "images1.jpg"));
        images.add(new ProductImage(2, "images2.jpg"));
        int[] results = insertImages(images);
        System.out.println("Inserted " + results.length +" images");

        int deletedCount = deleteProducts();
        System.out.println("Deleted " + deletedCount +" products");

        List<CategoryWithChildCount> categories = getTopParentCategory();
        System.out.println("Top Parent Categories ");
        categories.forEach(System.out::println);
    }
}