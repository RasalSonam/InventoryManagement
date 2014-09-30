
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RequestController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private RequestHandler requestHandler;
	private JDBCItemRepository repository;
	public RequestController() {
		super();
	}

	@Override
	public void init(ServletConfig config) throws ServletException {
		requestHandler = (RequestHandler) config.getServletContext().getAttribute("requestHandler");
		repository = (JDBCItemRepository) config.getServletContext().getAttribute("repository");
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/ViewAndApproveRequests.jsp");
		List<Request> requests = requestHandler.findPending();
		Collections.sort(requests);
		request.setAttribute("requests", requests);
		dispatcher.forward(request, response);

	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int empId = Integer.parseInt(request.getParameter("empId"));
		String name = request.getParameter("name");
		Boolean isActionDone = false;
		
		if (request.getParameter("action").equals("placeRequest")){
			SimpleDateFormat formatter =new SimpleDateFormat("EEE MMM d HH:mm:ss zzz yyyy");
			Date requestedOn = new Date();
			try {
				requestedOn = formatter.parse(request.getParameter("requestedOn"));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			int quantity = Integer.parseInt(request.getParameter("quantity"));
			String status = "pending";
			Item item = repository.findByName(name);
			Item requestedItem = new Item(name, quantity, item.getThreshold());
			Request employeeRequest = new Request(requestedOn, status, requestedItem, empId);
			isActionDone = requestHandler.add(employeeRequest);
		}
		else if (request.getParameter("action").equals("approveRequest")){
			SimpleDateFormat formatter1 =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date requestedDate = new Date();
			try {
				requestedDate = formatter1.parse(request.getParameter("requestedOn"));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			
			Request employeeRequest = new Request(requestedDate, "", new Item(name, 0, 0), empId);
			isActionDone = requestHandler.approve(employeeRequest);
		}
		else if (request.getParameter("action").equals("rejectRequest")){
			int quantity = Integer.parseInt(request.getParameter("quantity"));
			SimpleDateFormat formatter2 =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date requestedDate = new Date();
			try {
				requestedDate = formatter2.parse(request.getParameter("requestedOn"));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			
			Request employeeRequest = new Request(requestedDate, "", new Item(name, quantity, 0), empId);
			isActionDone = requestHandler.reject(employeeRequest);
		}
		response.setContentType("application/json");
		response.getWriter().append(isActionDone.toString());
		response.flushBuffer();
	}

}
