package com.tap.model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Cart represents the user's shopping basket.
 * Key Features:
 * 1. Tracks items mapped by their unique menuId for instant O(1) lookups.
 * 2. Enforces single-restaurant ordering constraint (food delivery apps like
 * Swiggy/Zomato
 * do not allow mixing dishes from different restaurants in one order).
 * 3. Provides helper calculations for total quantity, total price, and item
 * mutations.
 */
public class Cart {

    // Map storing menuId as key (Integer) and CartItem as value.
    // LinkedHashMap is chosen to preserve insertion order (items stay in the exact
    // order added).
    private Map<Integer, CartItem> items;

    // Stores the ID of the restaurant currently in this cart.
    // 0 means the cart is empty and hasn't been locked to any restaurant yet.
    private int restaurantId;

    /**
     * Constructor initializing an empty shopping cart.
     */
    public Cart() {
        // Initialize an empty LinkedHashMap ready to accept items
        items = new LinkedHashMap<>();
        // 0 signifies no restaurant has been selected yet
        restaurantId = 0;
    }

    /**
     * Adds a menu item to the cart or increments its quantity if already present.
     * Enforces single-restaurant restriction.
     * 
     * @param menu the Menu object representing the dish to add
     * @return true if added successfully, false if the item belongs to a different
     *         restaurant
     */
    public boolean addItem(Menu menu) {

        // Rule 1: If the cart is currently empty, lock the cart to this dish's
        // restaurant
        if (items.isEmpty()) {
            restaurantId = menu.getRestaurantId();
        }

        // Rule 2: Single-restaurant restriction.
        // If the dish's restaurantId doesn't match the cart's locked restaurantId,
        // reject the addition.
        if (restaurantId != menu.getRestaurantId()) {
            return false;
        }

        // Get the unique identifier of the dish
        int menuId = menu.getMenuId();

        // Check if this dish is already in the cart
        if (items.containsKey(menuId)) {
            // Retrieve existing CartItem entry
            CartItem existingItem = items.get(menuId);

            // Increment the quantity by 1
            existingItem.setQuantity(
                    existingItem.getQuantity() + 1);
        } else {
            // If item is not in cart yet, create a new CartItem with quantity = 1
            CartItem cartItem = new CartItem(menu, 1);
            // Insert it into our Map keyed by menuId
            items.put(menuId, cartItem);
        }

        // Successfully added
        return true;
    }

    /**
     * Updates the quantity of a specific item in the cart.
     * If quantity is updated to 0 or negative, the item is automatically removed.
     * 
     * @param menuId   the unique ID of the dish
     * @param quantity the new desired quantity
     */
    public void updateQuantity(int menuId, int quantity) {

        // Check if the item exists in the cart before updating
        if (items.containsKey(menuId)) {

            // If the user decremented to 0 or less, remove the item entirely
            if (quantity <= 0) {
                removeItem(menuId);
            } else {
                // Otherwise update the quantity of the existing CartItem
                CartItem cartItem = items.get(menuId);
                cartItem.setQuantity(quantity);
            }
        }
    }

    /**
     * Completely removes a dish from the cart by its menuId.
     * 
     * @param menuId the unique ID of the dish to remove
     */
    public void removeItem(int menuId) {

        // Remove entry from Map
        items.remove(menuId);

        // If cart is now empty after this removal, reset restaurantId to 0
        // This frees the cart so user can now order from any other restaurant
        if (items.isEmpty()) {
            restaurantId = 0;
        }
    }

    /**
     * Returns all CartItem objects in the cart as a Collection.
     * Used by JSPs (e.g. cart.jsp) to iterate through items and render the
     * table/list.
     * 
     * @return Collection of CartItem objects
     */
    public Collection<CartItem> getItems() {
        return items.values();
    }

    /**
     * Calculates the grand total price of all items currently in the cart.
     * Loops through each item, sums up (item.price * item.quantity).
     * 
     * @return total order amount in Rupees
     */
    public double getTotalAmount() {

        double total = 0;

        // Iterate through all CartItem entries in the cart
        for (CartItem item : items.values()) {
            // Add each item's subtotal to the running sum
            total += item.getSubtotal();
        }

        return total;
    }

    /**
     * Calculates the total count of all dishes in the cart (sum of quantities).
     * Useful for displaying badge count like "Cart (3)" in navigation bars.
     * 
     * @return total number of individual items in cart
     */
    public int getTotalQuantity() {

        int totalQuantity = 0;

        // Accumulate quantity from every CartItem
        for (CartItem item : items.values()) {
            totalQuantity += item.getQuantity();
        }

        return totalQuantity;
    }

    /**
     * Returns the restaurantId to which this cart belongs.
     * 
     * @return restaurantId (or 0 if cart is empty)
     */
    public int getRestaurantId() {
        return restaurantId;
    }

    /**
     * Checks if the shopping cart has 0 items.
     * 
     * @return true if empty, false otherwise
     */
    public boolean isEmpty() {
        return items.isEmpty();
    }

    /**
     * Retrieves a CartItem by its menuId.
     * 
     * @param menuId the unique ID of the dish
     * @return CartItem if present, or null if not in cart
     */
    public CartItem getItem(int menuId) {
        return items.get(menuId);
    }

    /**
     * Returns the quantity of a specific menu item currently in the cart.
     * Returns 0 if the item is not present in the cart.
     * 
     * @param menuId the unique ID of the dish
     * @return quantity of the item (0 if not in cart)
     */
    public int getItemQuantity(int menuId) {
        CartItem item = items.get(menuId);
        return (item != null) ? item.getQuantity() : 0;
    }

    /**
     * Completely wipes the cart clean (e.g. after order placement or cart reset).
     */
    public void clear() {
        // Clear all entries from the map
        items.clear();
        // Reset restaurant locking back to 0
        restaurantId = 0;
    }
}
