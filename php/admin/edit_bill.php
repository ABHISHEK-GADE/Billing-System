<?php
require_once '../../config/database.php';
require_once '../../includes/auth.php';

// Validate bill ID
$billId = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$billId) {
    die('Invalid Bill ID');
}

// Fetch bill and items
$stmt = $pdo->prepare("SELECT * FROM bills WHERE id = :id");
$stmt->execute(['id' => $billId]);
$bill = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$bill) {
    die('Bill not found.');
}

$stmt = $pdo->prepare("SELECT bi.*, p.name, p.price as product_price FROM bill_items bi INNER JOIN products p ON bi.product_id = p.id WHERE bi.bill_id = :bill_id");
$stmt->execute(['bill_id' => $billId]);
$billItems = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Fetch products
$stmt = $pdo->query("SELECT id, name, price FROM products");
$products = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Fetch clients
$clients = $pdo->query("SELECT id, name FROM users WHERE role = 'client'")->fetchAll(PDO::FETCH_ASSOC);

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $clientId = intval($_POST['client_id']);
    $items = json_decode($_POST['items'], true);
    $total = 0;

    foreach ($items as $item) {
        $total += $item['price'] * $item['quantity'];
    }

    // Update bill
    $stmt = $pdo->prepare("UPDATE bills SET client_id = :client_id, total = :total WHERE id = :id");
    $stmt->execute(['client_id' => $clientId, 'total' => $total, 'id' => $billId]);

    // Delete existing bill items
    $pdo->prepare("DELETE FROM bill_items WHERE bill_id = :bill_id")->execute(['bill_id' => $billId]);

    // Insert updated bill items
    $stmt = $pdo->prepare("INSERT INTO bill_items (bill_id, product_id, quantity, price) VALUES (:bill_id, :product_id, :quantity, :price)");
    foreach ($items as $item) {
        $stmt->execute([
            'bill_id' => $billId,
            'product_id' => $item['product_id'],
            'quantity' => $item['quantity'],
            'price' => $item['price']
        ]);
    }

    $success = "Bill updated successfully.";
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Bill</title>
    <link rel="stylesheet" href="../../assets/css/admin.css">
</head>

<body>
    <div class="dashboard">
        <header class="dashboard-header">
            <h1>Edit Bill #<?= htmlspecialchars($billId) ?></h1>
            <a href="manage_bills.php" class="btn btn-primary">Back to Bills</a>
        </header>

        <?php include 'sidebar.php'; ?>

        <main class="dashboard-content">
            <h2>Edit Bill Details</h2>

            <?php if (isset($success)): ?>
                <div class="alert alert-success"><?= htmlspecialchars($success) ?></div>
            <?php endif; ?>

            <form id="edit-bill-form" method="POST">
                <table class="user-table">
                    <thead>
                        <tr>
                            <th>Field</th>
                            <th>Input</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><label for="client_id">Select Client</label></td>
                            <td>
                                <select name="client_id" id="client_id" required>
                                    <?php foreach ($clients as $client): ?>
                                        <option value="<?= $client['id'] ?>" <?= $client['id'] == $bill['client_id'] ? 'selected' : '' ?>>
                                            <?= htmlspecialchars($client['name']) ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <h3>Edit Items</h3>
                                <table id="items-table" class="item-table">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Price</th>
                                            <th>Quantity</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($billItems as $item): ?>
                                            <tr>
                                                <td>
                                                    <select>
                                                        <?php foreach ($products as $product): ?>
                                                            <option value="<?= $product['id'] ?>" data-price="<?= $product['price'] ?>" <?= $product['id'] == $item['product_id'] ? 'selected' : '' ?>>
                                                                <?= htmlspecialchars($product['name']) ?> - ₹<?= $product['price'] ?>
                                                            </option>
                                                        <?php endforeach; ?>
                                                    </select>
                                                </td>
                                                <td><span class="product-price">₹<?= $item['price'] * $item['quantity'] ?></span></td>
                                                <td><input type="number" min="1" class="quantity" value="<?= $item['quantity'] ?>"></td>
                                                <td><button type="button" class="btn btn-danger" onclick="removeRow(this)">Remove</button></td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                                <button type="button" class="btn btn-primary" onclick="addItemRow()">Add Item</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: center;">
                                <input type="hidden" name="items" id="items-json">
                                <button type="submit" class="btn btn-primary" onclick="prepareItems()">Save Changes</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </main>
    </div>

    <script>
        const products = <?= json_encode($products) ?>;

        function addItemRow() {
            const table = document.querySelector('#items-table tbody');
            const row = document.createElement('tr');

            const productSelect = document.createElement('select');
            products.forEach(product => {
                const option = document.createElement('option');
                option.value = product.id;
                option.textContent = `${product.name} - ₹${product.price}`;
                option.dataset.price = product.price;
                productSelect.appendChild(option);
            });

            row.innerHTML = `
                <td></td>
                <td><span class="product-price">₹0</span></td>
                <td><input type="number" min="1" class="quantity" value="1"></td>
                <td><button type="button" class="btn btn-danger" onclick="removeRow(this)">Remove</button></td>
            `;

            row.cells[0].appendChild(productSelect);
            table.appendChild(row);

            const quantityInput = row.querySelector('.quantity');
            const priceSpan = row.querySelector('.product-price');

            const updatePrice = () => {
                const price = productSelect.selectedOptions[0].dataset.price;
                const quantity = quantityInput.value;
                priceSpan.textContent = `₹${(price * quantity).toFixed(2)}`;
            };

            productSelect.addEventListener('change', updatePrice);
            quantityInput.addEventListener('input', updatePrice);

            updatePrice();
        }

        function removeRow(button) {
            button.closest('tr').remove();
        }

        function prepareItems() {
            const rows = document.querySelectorAll('#items-table tbody tr');
            const items = Array.from(rows).map(row => {
                const productId = row.querySelector('select').value;
                const price = row.querySelector('select').selectedOptions[0].dataset.price;
                const quantity = row.querySelector('.quantity').value;

                return { product_id: productId, price, quantity };
            });

            document.querySelector('#items-json').value = JSON.stringify(items);
        }

        // Automatically calculate on page load
        document.querySelectorAll('#items-table tbody tr').forEach(row => {
            const select = row.querySelector('select');
            const quantityInput = row.querySelector('.quantity');
            const priceSpan = row.querySelector('.product-price');

            const updatePrice = () => {
                const price = select.selectedOptions[0].dataset.price;
                const quantity = quantityInput.value;
                priceSpan.textContent = `₹${(price * quantity).toFixed(2)}`;
            };

            select.addEventListener('change', updatePrice);
            quantityInput.addEventListener('input', updatePrice);

            updatePrice();
        });
    </script>
</body>

</html>
