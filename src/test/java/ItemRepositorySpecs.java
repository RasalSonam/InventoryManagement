import static org.junit.Assert.fail;

import java.sql.SQLException;
import java.util.List;
import junit.framework.*;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

public class ItemRepositorySpecs {
	private static final int NO_ITEMS = 0;
	private static ItemRepository repository;
	private static ItemRepositorySupport repositorySupport = new ItemRepositorySupport();
	
	@BeforeClass
	public static void createConnectionAndTable() throws ClassNotFoundException, SQLException{
		repository = repositorySupport.createTableAndRepository();
	}
	
	@AfterClass
	public static void dropTable() throws SQLException{
		repositorySupport.dropTable();
	}
	
	@After
	public void cleanTable() throws SQLException{
		repositorySupport.cleanTable();
	}
	
	@Test
	public void emptyRepositoryReturnsNothing() throws SQLException{
		List<Item> listOfItems = repository.findAll();
		Assert.assertEquals(NO_ITEMS, listOfItems.size());
	}
	
	@Test
	public void repositoryContainingOneItemReturnsOneItem() throws Exception{
		Item pen = new Item("Pen", 1, 0);
		repositorySupport.insert(pen);
		List<Item> listOfItems = repository.findAll();
		Assert.assertTrue(pen.equals(listOfItems.get(0)));
	}
	
	@Test
	public void newUniqueItemAddedToRepository(){
		Item eraser = new Item("eraser", 2, 0);
		Assert.assertTrue(repository.add(eraser));
	}
	
	@Test
	public void repositoryAlreadyContaininingItemDoesNotAllowDuplication() throws Exception{
		Item pen = new Item("pen", 1, 0);
		repositorySupport.insert(pen);
		Assert.assertFalse(repository.add(pen));
	}
	
	@Test
	public void repositoryCannotWorkWithoutAConnection(){
		try{
			new JDBCItemRepository(null);
			fail("Repository received connection when not expected");
		}catch(IllegalArgumentException e){
			Assert.assertEquals("Empty connection", e.getMessage());
		}
	}
}
