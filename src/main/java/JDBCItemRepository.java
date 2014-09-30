import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class JDBCItemRepository implements ItemRepository {
	private final Connection connection;

	public JDBCItemRepository(Connection connection) {
		if(connection == null)
			throw new IllegalArgumentException("Empty connection");
		this.connection = connection;
	}

	@Override
	public List<Item> findAll() {
		List<Item> listOfItems = new ArrayList<Item>();
		ResultSet rs;
		try {
			rs = connection.createStatement().executeQuery("select name, quantity, threshold from item");
			while (rs.next())
				listOfItems.add(new Item(rs.getString(1), rs.getInt(2), rs.getInt(3)));
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		return listOfItems;
	}

	public Item findByName(String name) {
		Item targetItem = null;
		try {
			ResultSet rs = connection.createStatement().executeQuery("select name, quantity, threshold from item where name = '" + name +"'");
			if(rs.next())
				targetItem = new Item(rs.getString(1), rs.getInt(2), rs.getInt(3));
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		return targetItem;
	}

	@Override
	public boolean add(Item item) {
		try {
			Item targetItem = findByName(item.getName());
			if(targetItem != null)
				return false;
			String insertIntoItem = String.format("insert into item (name, quantity, threshold) values(\'%s\', %d, %d)", item.getName(), item.getQuantity(), item.getThreshold());
			connection.createStatement().executeUpdate(insertIntoItem);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return true;
	}
	
	public boolean reduceCount(Item item) throws SQLException {
		ResultSet rs = connection.createStatement().executeQuery("select quantity from item where name = '" + item.getName() + "'");
		if(rs.next()){
			if(rs.getInt(1) - item.getQuantity() < 0)
				return false;
		}
		String updateQuery =  String.format(
				"update item set quantity = quantity - %d where name=\'%s\'", item.getQuantity(), item.getName());
		try {
			connection.createStatement().execute(updateQuery);
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		return true;
	}
	
	public boolean restoreQuantity(Item item) throws SQLException {
		
		String updateQuery =  String.format(
				"update item set quantity = quantity + %d where name=\'%s\'", item.getQuantity(), item.getName());
		try {
			connection.createStatement().execute(updateQuery);
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		return true;
	}
	
	@Override
	public boolean update(Item newItem, String name) {
		try {
			Item targetItem = findByName(name);
			if(targetItem != null)
			{
			String insertIntoItem = String.format("update item set name ='" +  newItem.getName() + "'," + 
					"quantity = " + newItem.getQuantity() + "," + "threshold = " + newItem.getThreshold() + 
					" where name = '" + name + "'");
			connection.createStatement().executeUpdate(insertIntoItem);
			return true;
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return false;
	}

}
