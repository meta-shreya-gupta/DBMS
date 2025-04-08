import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

class Queries{
    String query1 = "SELECT Orders.Order_Id , Orders.Order_Date , SUM(Order_Item.Price * Order_Item.Quantity) AS Order_Total FROM Orders JOIN Order_Item ON Orders.Order_Id = Order_Item.Order_Id WHERE Orders.User_Id = ? AND Order_Item.Status = 'SHIPPED' GROUP BY Orders.Order_Date , Orders.Order_Id ORDER BY Orders.Order_Date ASC";
    String query2 = "INSERT INTO Images(Prod_Id , Image_Url) VALUES (? , ?)";
    String dropFK = "ALTER TABLE Order_Item DROP FOREIGN KEY order_item_ibfk_2";
    String dropImage = "DELETE FROM Images WHERE Prod_Id IN (SELECT Prod_Id FROM Product WHERE Prod_Id NOT IN (SELECT DISTINCT Order_Item.Prod_Id FROM Orders JOIN Order_Item ON Orders.Order_Id = Order_Item.Order_Id WHERE Orders.Order_Date >+ NOW() - INTERVAL 1 YEAR))";
    String dropCategory = "DELETE FROM product_category WHERE Prod_Id  IN (SELECT Prod_Id FROM Product WHERE Prod_Id NOT IN (SELECT DISTINCT Order_Item.Prod_Id FROM Orders JOIN Order_Item ON Orders.Order_ID = Order_Item.Order_ID WHERE  Orders.Order_Date>= NOW()-INTERVAL 1 YEAR))";
    String query3 = "DELETE FROM Product WHERE Prod_Id NOT IN (SELECT DISTINCT Order_Item.Prod_Id FROM Order_Item JOIN Orders ON Order_Item.Order_Id = Orders.Order_Id WHERE Orders.Order_Date >= NOW() - INTERVAL 1 YEAR)";
    String query4 = "SELECT c1.Cat_Title , COUNT(c2.Cat_Id) AS Child_Count FROM Category c1 LEFT JOIN Category c2 ON c1.Cat_Id = c2.Parent_Category WHERE c1.Parent_Category IS NULL GROUP BY c1.Cat_Id , c1.Cat_Title ORDER BY c1.Cat_Title ASC";
}

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
        return String.format("Cat_Title = %s , Children = %d" , catTitle , childCount);
    }
}

public class Assignment2 {
    private static final String host = "jdbc:mysql://localhost:3306/";
    private static final String dbName = "StoreFront2";
    private static final String mysqlURL = host + dbName;
    private static final String user = "root";
    private static final String password = "root";
    static Queries queries = new Queries();
    public static List<Order> getShippedOrder(int userId){
        List<Order> orders = new ArrayList<>();
        try(Connection connection = DriverManager.getConnection(mysqlURL , user , password);
        PreparedStatement preparedStatement1 = connection.prepareStatement(queries.query1);){
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
        try(Connection connection = DriverManager.getConnection(mysqlURL , user , password);
        PreparedStatement preparedStatement2 = connection.prepareStatement(queries.query2)){
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
    public static int deletedProducts(){
        int result4 = 0;
        try{
            Connection connection = DriverManager.getConnection(mysqlURL, user, password);
            PreparedStatement preparedStatement = connection.prepareStatement(queries.dropFK);
            int result1 = preparedStatement.executeUpdate();
            PreparedStatement preparedStatement1 = connection.prepareStatement(queries.dropImage);
            int result2 = preparedStatement1.executeUpdate();
            PreparedStatement preparedStatement2 = connection.prepareStatement(queries.dropCategory);
            int result3 = preparedStatement2.executeUpdate();
            PreparedStatement preparedStatement3 = connection.prepareStatement(queries.query3);
            result4 = preparedStatement3.executeUpdate();

        }catch(SQLException e){
            e.printStackTrace();
        }
        return result4;
    }
    public static List<CategoryWithChildCount> getTopParentCategory(){
        List<CategoryWithChildCount> categories = new ArrayList<>();
        try(Connection connection = DriverManager.getConnection(mysqlURL, user, password);
        PreparedStatement preparedStatement4 = connection.prepareStatement(queries.query4);
        ResultSet rs = preparedStatement4.executeQuery(queries.query4);){
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
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter the userId for data fetch (1,2,3,4,5)");
        int userID = sc.nextInt();
        List<Order> shippedOrder = getShippedOrder(userID);
        shippedOrder.forEach(System.out::println);

        List<ProductImage> images = new ArrayList<>();
        images.add(new ProductImage(1, "images1.jpg"));
        images.add(new ProductImage(2, "images2.jpg"));
        int[] results = insertImages(images);
        System.out.println("Inserted " + results.length +" images");

        int deletedCount = deletedProducts();
        System.out.println("Deleted " + deletedCount +" products");

        List<CategoryWithChildCount> categories = getTopParentCategory();
        System.out.println("Top Parent Categories ");
        categories.forEach(System.out::println);
        
        sc.close();
    }
}
