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
        return "Order_Id : " + order_Id + ", Order_Date : " + order_Date +" , Order_Total : " + order_Total;
    }
}
public class Assignment {
    public static void main(String[] args) throws SQLException {
        String host = "jdbc:mysql://localhost:3306/";
        String dbName = "StoreFront2";
        String mysqlURL = host + dbName;
        String user = "root";
        String password = "root";
        List<Order> orders = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

        } catch (ClassNotFoundException cnfe) {
            System.out.println("Error Loading Driver : " + cnfe);
        }
        try{
            Connection connection = DriverManager.getConnection(mysqlURL, user, password);
            PreparedStatement prepareStatement = connection.prepareStatement("SELECT Orders.Order_Id , Orders.Order_Date , SUM(Order_Item.Price * Order_Item.Quantity) AS OrderTotal FROM Orders JOIN Order_Item ON Orders.Order_Id = Order_Item.Order_Id WHERE Orders.User_Id = ? AND Order_Item.status = 'SHIPPED' GROUP BY Orders.Order_Id ORDER BY Orders.Order_Date ASC;");
            prepareStatement.setString(1, "4");
            ResultSet resObj = prepareStatement.executeQuery();
            while(resObj.next()) {
                int order_Id = resObj.getInt("Order_Id");
                String order_Date = resObj.getString("Order_Date");
                double order_Total = resObj.getDouble("Order_Total");
                Order order = new Order(order_Id , order_Date , order_Total);
                orders.add(order);

            }
        }catch(SQLException e){
            e.printStackTrace();
        }
        for(Order order : orders){
            System.out.println(order);
        }

    }
}