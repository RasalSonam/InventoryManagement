import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class IMSServletContextListener implements ServletContextListener {
	private ItemRepository repository;
	private RequestHandler requestHandler;
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		//System.out.println("IMSServletContextListener.contextInitialized()");
		ServletContext servletContext = sce.getServletContext();
		try {
			Class.forName(servletContext.getInitParameter("driver"));
			Connection connection = DriverManager.getConnection(
					servletContext.getInitParameter("url"),
					servletContext.getInitParameter("username"),
					servletContext.getInitParameter("password"));
			repository = new JDBCItemRepository(connection);
			servletContext.setAttribute("repository", repository);
			requestHandler = new RequestHandler(connection);
			servletContext.setAttribute("requestHandler", requestHandler);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
	}
}
