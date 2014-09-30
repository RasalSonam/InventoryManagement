
import junit.framework.Assert;

import org.eclipse.jetty.testing.HttpTester;
import org.eclipse.jetty.testing.ServletTester;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.mockito.Mockito.*;

public class RequestControllerSpecs {
	private static ItemRepository repository = mock(ItemRepository.class);
	private static ServletTester servletTester;
		
	@BeforeClass
	public static void setUp() throws Exception{
		servletTester = startServer();
	}
	
	private static ServletTester startServer() throws Exception {
		ServletTester servletTester = new ServletTester();
		servletTester.setContextPath("/");
		servletTester.addServlet(ItemController.class, "/items");
		servletTester.setAttribute("repository", repository);
		servletTester.start();
		return servletTester;
	}
	
	@Test
	public void getRequestOnItemsForAdminIsSuccessful() throws Exception{
		HttpTester httpRequestTester = new HttpTester();
		httpRequestTester.setMethod("GET");
		httpRequestTester.setURI("/items?user=admin");
		httpRequestTester.setVersion("HTTP/1.0");
		HttpTester httpResponseTester = new HttpTester();
		httpResponseTester.parse(servletTester.getResponses(httpRequestTester.generate()));
		Assert.assertEquals(200, httpResponseTester.getStatus());
	}
	
	@Test
	public void postToItemsForAdminIsSuccessful() throws Exception{
		HttpTester httpRequestTester = new HttpTester();
		httpRequestTester.setMethod("POST");
		httpRequestTester.setURI("/items?user=admin");
		httpRequestTester.setVersion("HTTP/1.0");
		httpRequestTester.setHeader("Host", "tester");
		httpRequestTester.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
		httpRequestTester.setContent("name=10&quantity=10&threshold=0");
		HttpTester httpResponseTester = new HttpTester();
		httpResponseTester.parse(servletTester.getResponses(httpRequestTester.generate()));
		Assert.assertEquals(200, httpResponseTester.getStatus());
	}
	
	@Test
	public void getRequestOnItemsForEmployeeIsSuccessful() throws Exception{
		HttpTester httpRequestTester = new HttpTester();
		httpRequestTester.setMethod("GET");
		httpRequestTester.setURI("/items?user=employee");
		httpRequestTester.setVersion("HTTP/1.0");
		HttpTester httpResponseTester = new HttpTester();
		httpResponseTester.parse(servletTester.getResponses(httpRequestTester.generate()));
		Assert.assertEquals(200, httpResponseTester.getStatus());
		
	}
}

