import java.util.Date;

public class Request implements Comparable<Request> {
	private String status;
	private Item item;
	private int empId;
	private Date requestedOn;
	
	public Request(Date requestedOn, String status, Item item, int empId) {
		this.requestedOn = requestedOn;
		this.status = status;
		this.item = item;
		this.empId = empId;
		
	}
	
	public Item getItem(){
		return item;
	}

	public int getEmpId() {
		return empId;
	}
	
	public Date getRequestedDateTime(){
		return requestedOn;
	}
	
	public String getStatus(){
		return status;
	}
	
	@Override
	public boolean equals(Object other) {
		if (other == null) {
			return false;
		}
		if (this.getClass() != other.getClass()) {
			return false;
		}
		Request that = (Request) other;
		if (this == that) {
			return true;
		}
		System.out.println(this.requestedOn);
		System.out.println(that.requestedOn);
		return this.status.equals(that.status) && (this.empId == that.empId) &&
				this.item.equals(that.item)
				;
	}

	public int compareTo(Request other) {
		return other.requestedOn.compareTo(this.requestedOn);
	}
}
