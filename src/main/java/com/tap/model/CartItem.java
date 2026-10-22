package com.tap.model;

/**
 * CartItem represents a single entry/line-item inside the shopping cart.
 * It pairs:
 * 1. A Menu object (containing itemName, price, description, restaurantId,
 * image, etc.)
 * 2. An integer quantity (how many units of this dish the user is ordering)
 */
public class CartItem {

    // The dish/food item details
    private Menu menu;

    // Number of units of this dish added to the cart (e.g., 1, 2, 3...)
    private int quantity;

    /**
     * Default zero-argument constructor.
     * Required for JavaBean standard and serialization.
     */
    public CartItem() {

    }

    /**
     * Parameterized constructor to create a CartItem with a specific Menu object
     * and quantity.
     * 
     * @param menu     the dish/food item
     * @param quantity the number of units to order
     */
    public CartItem(Menu menu, int quantity) {
        // "this.menu" assigns the parameter to the instance variable of this object
        this.menu = menu;
        // "this.quantity" assigns the quantity parameter to the instance variable
        this.quantity = quantity;
    }

    /**
     * Getter for the Menu object.
     * Allows other classes (like cart.jsp or Cart.java) to access dish details.
     * 
     * @return the Menu object
     */
    public Menu getMenu() {
        return menu;
    }

    /**
     * Setter for the Menu object.
     * Allows updating or replacing the associated dish.
     * 
     * @param menu the Menu object to set
     */
    public void setMenu(Menu menu) {
        this.menu = menu;
    }

    /**
     * Getter for the quantity of this item.
     * 
     * @return the current count of this dish in the cart
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     * Setter to modify the quantity (e.g., when the user increments or decrements
     * quantity).
     * 
     * @param quantity the updated quantity
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    /**
     * Calculates the subtotal price for this specific cart item:
     * Subtotal = (price of single dish) * (number of units ordered).
     * 
     * @return subtotal amount as double
     */
    public double getSubtotal() {
        return menu.getPrice() * quantity;
    }

    /**
     * Overrides toString() to print readable details of the cart item during
     * debugging.
     */
    @Override
    public String toString() {
        return "CartItem [menu=" + menu
                + ", quantity=" + quantity
                + ", subtotal=" + getSubtotal() + "]";
    }
}
