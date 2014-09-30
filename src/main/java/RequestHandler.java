import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RequestHandler {
	private Connection connection;
	
	public RequestHandler(Connection connection) {
		this.connection = connection;
	}
	
	public boolean add(Request request) {

		java.sql.PreparedStatement ps;
		try {
			boolean countReduced = new JDBCItemRepository(connection).reduceCount(request.getItem());
			if(countReduced == false)
				return false;
			ps = connection.prepareStatement("insert into item_requests (empId, item_name,quantity, requested_on, status) values(?,?,?,?,?)");
			ps.setInt(1, request.getEmpId());
			ps.setString(2, request.getItem().getName());
			ps.setInt(3, request.getItem().getQuantity());
			ps.setObject(4, new java.sql.Timestamp(request.getRequestedDateTime().getTime()));
			ps.setString(5, request.getStatus());
			ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}

	public List<Request> findPending() {
		List<Request> requests = new ArrayList<Request>();
		ResultSet rs;
		try {
			rs = connection
					.createStatement()
					.executeQuery(
							"select requested_on,empId,item_name, quantity FROM item_requests where status = 'pending'");
			while (rs.next()) {
				Request request = new Request(rs.getTimestamp(1), "pending",
						new Item(rs.getString(3), rs.getInt(4), 0), rs.getInt(2));
				requests.add(request);
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		return requests;
	}

	public Boolean approve(Request request) {
		java.sql.PreparedStatement ps;
		try {
			ps = connection.prepareStatement("update item_requests set status = 'approved' where empId = ? and item_name = ? and requested_on = ?");
			ps.setInt(1, request.getEmpId());
			ps.setString(2, request.getItem().getName());
			ps.setObject(3, new java.sql.Timestamp(request.getRequestedDateTime().getTime()));
			ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
	public Boolean reject(Request request) {
		java.sql.PreparedStatement ps;
		try {
			boolean quantityRestored = new JDBCItemRepository(connection).restoreQuantity(request.getItem());
			if(quantityRestored == false)
				return false;
			ps = connection.prepareStatement("delete from item_requests where empId = ? and item_name = ? and requested_on = ?");
			ps.setInt(1, request.getEmpId());
			ps.setString(2, request.getItem().getName());
			ps.setObject(3, new java.sql.Timestamp(request.getRequestedDateTime().getTime()));
			ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
	
}
