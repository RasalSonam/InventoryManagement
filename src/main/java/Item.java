
public class Item implements Comparable<Item> {
	private final String name;
	private final int quantity;
	private final int threshold;
	
	public Item(String name, int quantity, int threshold) {
		this.name = name;
		this.quantity = quantity;
		this.threshold = threshold;
	}

	public String getName() {
		return name;
	}

	public int getQuantity() {
		return quantity;
	}

	public int getThreshold(){
		return threshold;
	}
	
	@Override
	public boolean equals(Object other) {
		if (this == null || other == null)
			return false;
		Item that = (Item) other;
		if (this.getClass() == that.getClass())
			return true;
		return this.name.equals(that.name)
				&& this.quantity == that.quantity
				&& this.threshold == that.threshold;
	}

	@Override
	public int compareTo(Item other) {
		return this.getName().compareToIgnoreCase(other.getName());
	}
}
