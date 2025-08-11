<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isELIgnored="true" %>
<html>
<head>
    <title>Catálogo de Produtos</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            color: white;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 2rem auto;
        }

        h1 { text-align: center; }
        table { border-collapse: collapse; width: 100%; background: white; color: black; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.2); }
        
        th, td { 
            padding: 12px 15px; 
            border-bottom: 1px solid #ddd; 
            vertical-align: middle;
        }
        
        th { 
            background-color: #4CAF50; 
            color: white; 
            text-align: left;
        }

        #productsTable th:nth-last-child(2),
        #productsTable td:nth-last-child(2) {
            text-align: right;
        }

        #productsTable th:last-child,
        #productsTable td:last-child {
            text-align: center;
        }

        tr:hover { background-color: #f1f1f1; }
        
        .header-actions {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            gap: 10px;
            margin-bottom: 1rem;
        }

        .btn { display: inline-block; padding: 8px 12px; color: white; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; text-align: center; }
        .logout { background-color: crimson; }
        .logout:hover { background-color: darkred; }
        .cart-link-btn { background-color: #ff9800; }
        .cart-link-btn:hover { background-color: #f57c00; }
        
        .quantity-input {
            width: 60px;
            padding: 5px;
            text-align: center;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-right: 10px;
        }
        .cart-btn {
            background-color: #007bff;
            padding: 6px 12px;
        }
        .cart-btn:hover {
            background-color: #0056b3;
        }
        .cart-btn:disabled {
            background-color: #28a745;
            cursor: not-allowed;
        }

    </style>
</head>
<body>
    <div class="container">
        <div class="header-actions">
            <button class="btn logout" onclick="logout()">Sair</button>
            <a href="/cart" class="btn cart-link-btn">🛒 Ver Carrinho</a>
        </div>
        <h1>Catálogo de Produtos</h1>

        <table id="productsTable">
            <thead>
                <tr>
                    <th>Fornecedor</th>
                    <th>Nome</th>
                    <th>Descrição</th>
                    <th>Preço</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <script>
        const token = localStorage.getItem("token");

        if (!token) {
            alert("Token não encontrado! Faça login novamente.");
            window.location.href = "/login";
        } else {
            loadProducts();
        }

        function loadProducts() {
            fetch("/api/v1/product", {
                method: "GET",
                headers: { "Authorization": "Bearer " + token }
            })
            .then(response => response.ok ? response.json() : Promise.reject(response))
            .then(data => {
                const productsData = Array.isArray(data) ? data : (data.content || []);
                const tbody = document.querySelector("#productsTable tbody");
                tbody.innerHTML = "";
                productsData.forEach(product => {
                    const priceFormatted = `R$ ${Number(product.price || 0).toFixed(2)}`;
                    tbody.innerHTML += `
                        <tr id="row-${product.id}">
                            <td>${product.supplierName || 'N/A'}</td>
                            <td>${product.name}</td>
                            <td>${product.description}</td>
                            <td>${priceFormatted}</td>
                            <td>
                                <input class="quantity-input" type="number" id="quantity-${product.id}" value="1" min="1" step="1" />
                                <button class="btn cart-btn" onclick="addToCart(event, ${product.id})">Adicionar</button>
                            </td>
                        </tr>
                    `;
                });
            })
            .catch(err => {
                console.error("Erro ao carregar produtos:", err);
                alert("Não foi possível carregar os produtos.");
            });
        }
        
        function addToCart(event, productId) {
            const quantityInput = document.getElementById(`quantity-${productId}`);
            const quant = parseInt(quantityInput.value, 10);

            if (isNaN(quant) || quant <= 0) {
                alert("Por favor, insira uma quantidade válida.");
                return;
            }

            const orderData = { quant, productId };
            const clickedButton = event.target;

            fetch("/api/v1/order/create", {
                method: "POST",
                headers: {
                    "Authorization": "Bearer " + token,
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(orderData)
            })
            .then(response => {
                if (!response.ok) {
                    return Promise.reject(response);
                }
                clickedButton.innerText = "Adicionado!";
                clickedButton.disabled = true;
                setTimeout(() => {
                    clickedButton.innerText = "Adicionar";
                    clickedButton.disabled = false;
                }, 2000);
            })
            .catch(err => {
                console.error("Erro ao criar pedido:", err);
                alert("Não foi possível adicionar o produto ao carrinho.");
            });
        }

        function logout() {
            localStorage.clear();
            window.location.href = "/login";
        }
    </script>
</body>
</html>
