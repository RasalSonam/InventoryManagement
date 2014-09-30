import java.io.IOException;
import java.util.Collections;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import waffle.windows.auth.IWindowsAccount;
import waffle.windows.auth.impl.WindowsAuthProviderImpl;

@WebServlet(urlPatterns = "/items") //if same servlet handles two or more patterns, provide comma separated list
public class ItemController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ItemRepository repository;

	@Override
	public void init(ServletConfig config) throws ServletException {
		repository = (ItemRepository) config.getServletContext().getAttribute("repository");
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String user = (String) request.getAttribute("user");
		RequestDispatcher dispatcher = null;
		List<Item> items = repository.findAll();
		Collections.sort(items);
		request.setAttribute("itemList", items);
		if(user.equalsIgnoreCase("idnsor"))
			dispatcher = request.getRequestDispatcher("/DisplayAndAddItems.jsp");
		else {
			ActiveDirectoryUserInfo userInfo = null;
			UserDTO userDetails = null;
			WindowsAuthProviderImpl provider = new WindowsAuthProviderImpl();
			IWindowsAccount account = provider.lookupAccount(user);
			try {
				userInfo = new ActiveDirectoryUserInfo(account.getFqn(), "employeeID,sn,givenName,mail");
				userDetails = userInfo.getUserDetails();
			} catch (AuthenticationError e) {
				userDetails = new UserDTO("", "", "");
			}
			request.setAttribute("employeeId", userDetails.getEmployeeID());
			dispatcher = request.getRequestDispatcher("/ViewAndRequestItems.jsp");
		}
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String user = request.getParameter("user");
		if(user.equals("admin")){
			if(request.getParameter("action").equals("addItem")){
				String itemName = request.getParameter("name");
				int quantity = Integer.parseInt(request.getParameter("quantity"));
				int threshold = Integer.parseInt(request.getParameter("threshold"));
				Boolean isAdded = repository.add(new Item(itemName, quantity, threshold));
				response.setContentType("application/json");
				response.getWriter().append(isAdded.toString());
				response.flushBuffer();
			}
			if (request.getParameter("action").equals("updateItem"))
			{
				String itemName = request.getParameter("nameUpdate");
				int quantity = Integer.parseInt(request.getParameter("quantityUpdate"));
				int threshold = Integer.parseInt(request.getParameter("thresholdUpdate"));
				//Boolean isAdded = repository.add(new Item(itemName, quantity, threshold));
				String oldName = request.getParameter("oldName");
				Boolean isUpdated = repository.update(new Item(itemName, quantity, threshold), oldName );
				Boolean isDone = isUpdated;
				if (isDone )
				response.setContentType("application/json");
				response.getWriter().append(isDone.toString());
				response.flushBuffer();
			}
		}
/*		else{
			RequestDispatcher dispatcher = request.getRequestDispatcher("RequestController");
			dispatcher.forward(request, response);
		}
*/	}

}
