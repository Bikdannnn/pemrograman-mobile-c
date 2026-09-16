import 'dart:io';

void main() {
  // 1. Store price list using Map (built-in type)
  Map<String, double> priceList = {
    'Apple': 1.20,
    'Banana': 0.80,
    'Orange': 1.50,
    'Milk': 3.50,
    'Bread': 2.50,
    'Eggs': 3.80,
    'Cheese': 4.50,
    'Coffee': 8.00,
    'Tea': 3.00,
    'Sugar': 2.00,
    'Rice': 5.50,
    'Cooking Oil': 4.20,
    'Chicken': 7.50,
    'Beef': 12.00,
    'Fish': 6.50,
    'Noodles': 0.99,
    'Chocolate': 2.80,
    'Yogurt': 1.50,
    'Water': 1.00,
    'Juice': 2.70,
  };

  print("Price List:");
  for (var entry in priceList.entries) {
    print('${entry.key}: \$${entry.value.toStringAsFixed(0)}');
  }

  // 2. Store shopping list using List (built-in type)
  List<String>? shoppingList;

  Map<String, double> lowerCaseMap = priceList.map(
    (key, value) => MapEntry(key.toLowerCase(), value),
  );
  print("Enter item name to add to the cart (or type 'done' to finish):");
  while (true) {
    String? item = stdin.readLineSync();
   
    if (item != null) {
      item = item.toLowerCase();
      
      if (item == 'done') {
        break;
      }
      
      shoppingList ??= [];
      if (!lowerCaseMap.containsKey(item)) {
        print("Item '$item' is not in the price list.");
        continue;
      } 
      else {
        print("$item added");
        shoppingList.add(item);
      }
    }
  }

  // 3 & 4. Process discount cases and display final total
  double total = calculateFinalTotal(shoppingList, lowerCaseMap);
  print('Final Total:\$ ${total.toStringAsFixed(0)}');
}

// Function to calculate total price and apply discounts
double calculateFinalTotal(List<String>? cart, Map<String, double> priceList) {
  double subtotal = 0.0;

  // Calculate total price of itemized shopping list
  if (cart != null) {
    for (var item in cart) {
      if (priceList.containsKey(item)) {
        subtotal += priceList[item]!;
      }
    }
  }

  double discountPercent = 0.0;

  // Determine discount using comparison operators and if/else if/else
  if (subtotal >= 100) {
    discountPercent = 0.20; // 20% discount
  } else if (subtotal >= 50) {
    discountPercent = 0.10; // 10% discount
  } else {
    discountPercent = 0.0; // No discount
  }

  double discountAmount = subtotal * discountPercent;
  double finalTotal = subtotal - discountAmount;

  print('Subtotal: \$${subtotal.toStringAsFixed(0)}');
  print(
    'Discount: ${(discountPercent * 100).toInt()}% (\$${discountAmount.toStringAsFixed(0)})',
  );

  return finalTotal;
}
