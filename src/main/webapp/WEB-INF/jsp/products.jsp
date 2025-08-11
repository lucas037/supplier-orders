<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<html>
<head>
    <title>Seus Produtos</title>
    <style>
        /* Estilos gerais da página, inspirados no histórico de transações */
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            margin: 0;
            padding: 2rem 0;
        }
        
        .container {
            background-color: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0px 4px 12px rgba(0,0,0,0.2);
            width: 90%;
            max-width: 1200px;
        }

        .header {
            display: flex;
            justify-content: flex-start; /* Alinha os botões à esquerda */
            align-items: center;
            margin-bottom: 1rem;
            flex-wrap: wrap;
            gap: 10px; 
        }

        .main-title {
            color: #333;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .btn { 
            display: inline-block; 
            padding: 8px 12px; 
            color: white; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            text-decoration: none; 
            text-align: center; 
            font-weight: bold;
            transition: background-color 0.3s, transform 0.2s;
        }
        .btn:hover {
            transform: translateY(-2px);
        }

        .logout { background-color: crimson; }
        .logout:hover { background-color: darkred; }
        .nav-btn { background-color: #3498db; }
        .nav-btn:hover { background-color: #2980b9; }
        .add-btn { background-color: #28a745; }
        .add-btn:hover { background-color: #218838; }

        #productsTable {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            color: #333;
        }

        #productsTable th, #productsTable td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
        }

        #productsTable th {
            background-color: #3a7bd5;
            font-weight: bold;
            color: white;
        }
        #productsTable tr:hover { background-color: #f1f1f1; }
        
        .action-btn { padding: 5px 10px; margin: 0 4px; color: white; }
        .edit-btn { background-color: #ffc107; }
        .edit-btn:hover { background-color: #e0a800; }
        .delete-btn { background-color: #dc3545; }
        .delete-btn:hover { background-color: #c82333; }

        .status-message {
            font-style: italic;
            color: #555;
            text-align: center;
            margin-top: 2rem;
            font-size: 1.1em;
        }
        
        /* Estilos do Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.6);
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background-color: #fff;
            color: #333;
            padding: 25px 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 450px;
            text-align: left;
        }
        .modal-content h3 { margin-top: 0; }
        .modal-content input[type="text"], .modal-content input[type="number"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 8px 0 16px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .modal-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .save-btn { background-color: #28a745; }
        .save-btn:hover { background-color: #218838; }
        .close-btn { background-color: #6c757d; }
        .close-btn:hover { background-color: #5a6268; }

    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <button class="btn logout" onclick="logout()">Sair</button>
            <a href="/transaction-history" class="btn nav-btn">Histórico</a>
            <button class="btn add-btn" onclick="openAddModal()">+ Adicionar Produto</button>
        </div>

        <h2 class="main-title">Seus Produtos</h2>

        <div id="products-content">
            <p id="loading-message" class="status-message">Carregando seus produtos...</p>
            <table id="productsTable" style="display:none;">
                <thead>
                    <tr>
                        <th>Nome</th>
                        <th>Descrição</th>
                        <th>Preço</th>
                        <th>Desconto</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody id="products-body"></tbody>
            </table>
        </div>
    </div>

    <!-- Modal para Adicionar/Editar Produto -->
    <div id="productModal" class="modal">
        <div class="modal-content">
            <h3 id="modalTitle"></h3>
            <input type="hidden" id="productId" />
            <label for="name">Nome do Produto</label>
            <input type="text" id="name" required/>
            <label for="description">Descrição</label>
            <input type="text" id="description" required/>
            <label for="price">Preço</label>
            <input type="number" id="price" step="0.01" required/>
            
            <div>
                <label>Desconto:</label>
                <div style="margin-top: 5px; padding-bottom: 10px;">
                    <input type="radio" id="discount0" name="discount" value="0.00"> <label for="discount0" style="margin-right: 10px;">0%</label>
                    <input type="radio" id="discount5" name="discount" value="0.05"> <label for="discount5" style="margin-right: 10px;">5%</label>
                    <input type="radio" id="discount10" name="discount" value="0.10"> <label for="discount10" style="margin-right: 10px;">10%</label>
                    <input type="radio" id="discount15" name="discount" value="0.15"> <label for="discount15" style="margin-right: 10px;">15%</label>
                    <input type="radio" id="discount25" name="discount" value="0.25"> <label for="discount25">25%</label>
                </div>
            </div>

            <div class="modal-buttons">
                <button class="btn close-btn" onclick="closeModal('productModal')">Cancelar</button>
                <button id="saveBtn" class="btn save-btn" onclick="handleSave()">Salvar</button>
            </div>
        </div>
    </div>
    
    <!-- Modal de Confirmação para Deleção -->
    <div id="confirmationModal" class="modal">
        <div class="modal-content" style="text-align:center;">
             <h3>Confirmar Remoção</h3>
             <p>Tem certeza que deseja remover este produto?</p>
             <div class="modal-buttons" style="justify-content:center;">
                <button class="btn close-btn" onclick="closeModal('confirmationModal')">Cancelar</button>
                <button id="confirmDeleteBtn" class="btn delete-btn">Confirmar</button>
            </div>
        </div>
    </div>

    <script>
        const token = localStorage.getItem("token");
        const productModal = document.getElementById("productModal");
        const confirmationModal = document.getElementById("confirmationModal");
        const loadingMessage = document.getElementById('loading-message');
        const table = document.getElementById('productsTable');
        const tableBody = document.getElementById('products-body');
        let productsData = [];
        let productToDeleteId = null;

        if (!token) {
            alert("Token não encontrado! Faça login novamente.");
            window.location.href = "/login";
        } else {
            loadProducts();
        }

        function loadProducts() {
            loadingMessage.style.display = 'block';
            table.style.display = 'none';
            fetch("/api/v1/product/supplier", {
                method: "GET",
                headers: { "Authorization": "Bearer " + token }
            })
            .then(response => response.ok ? response.json() : Promise.reject(response))
            .then(data => {
                productsData = Array.isArray(data) ? data : (data.content || []);
                renderProducts();
            })
            .catch(err => {
                console.error("Erro ao carregar produtos:", err);
                loadingMessage.textContent = "Não foi possível carregar os produtos.";
            });
        }

        function renderProducts() {
            tableBody.innerHTML = "";
            if (productsData.length === 0) {
                loadingMessage.textContent = "Nenhum produto cadastrado.";
                table.style.display = 'none';
            } else {
                loadingMessage.style.display = 'none';
                table.style.display = 'table';
                productsData.forEach(product => {
                    const priceFormatted = `R$ ${Number(product.price || 0).toFixed(2)}`;
                    const discountFormatted = `${(product.discount || 0) * 100}%`;
                    tableBody.innerHTML += `
                        <tr id="row-${product.id}">
                            <td>${product.name}</td>
                            <td>${product.description}</td>
                            <td>${priceFormatted}</td>
                            <td>${discountFormatted}</td>
                            <td>
                                <button class="btn action-btn edit-btn" onclick="openEditModal(${product.id})">Editar</button>
                                <button class="btn action-btn delete-btn" onclick="openDeleteModal(${product.id})">Remover</button>
                            </td>
                        </tr>
                    `;
                });
            }
        }
        
        function openDeleteModal(id) {
            productToDeleteId = id;
            confirmationModal.style.display = "flex";
            document.getElementById('confirmDeleteBtn').onclick = () => deleteProduct();
        }

        function deleteProduct() {
            if (!productToDeleteId) return;
            fetch(`/api/v1/product/delete/${productToDeleteId}`, {
                method: "DELETE",
                headers: { "Authorization": "Bearer " + token }
            })
            .then(response => {
                if (!response.ok) return Promise.reject(response);
                closeModal('confirmationModal');
                loadProducts();
            })
            .catch(err => {
                console.error("Erro ao remover produto:", err);
                alert("Não foi possível remover o produto.");
                closeModal('confirmationModal');
            });
        }

        function openAddModal() {
            document.getElementById("modalTitle").innerText = "Adicionar Novo Produto";
            document.getElementById("productId").value = "";
            document.getElementById("name").value = "";
            document.getElementById("description").value = "";
            document.getElementById("price").value = "";
            document.getElementById("discount0").checked = true;
            productModal.style.display = "flex";
        }
        
        function openEditModal(id) {
            const product = productsData.find(p => p.id === id);
            if (!product) return;

            document.getElementById("modalTitle").innerText = `Editar Produto`;
            document.getElementById("productId").value = product.id;
            document.getElementById("name").value = product.name;
            document.getElementById("description").value = product.description;
            document.getElementById("price").value = product.price;
            
            const discountValue = product.discount || 0.00;
            const radioToCheck = document.querySelector(`input[name="discount"][value="${discountValue.toFixed(2)}"]`);
            if (radioToCheck) {
                radioToCheck.checked = true;
            } else {
                document.getElementById("discount0").checked = true;
            }
            productModal.style.display = "flex";
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
        }

        function handleSave() {
            const id = document.getElementById("productId").value;
            const name = document.getElementById("name").value.trim();
            const description = document.getElementById("description").value.trim();
            const price = parseFloat(document.getElementById("price").value);
            const discount = parseFloat(document.querySelector('input[name="discount"]:checked').value);

            if (!name || !description || isNaN(price) || price < 0) {
                alert("Por favor, preencha todos os campos corretamente.");
                return;
            }

            const productData = { name, description, price, discount };
            const isUpdate = !!id;
            const url = isUpdate ? `/api/v1/product/update/${id}` : "/api/v1/product/create";
            const method = isUpdate ? "PUT" : "POST";
            
            fetch(url, {
                method: method,
                headers: {
                    "Authorization": "Bearer " + token,
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(productData)
            })
            .then(response => {
                if (!response.ok) return Promise.reject(response);
                closeModal('productModal');
                loadProducts();
            })
            .catch(err => {
               console.error("Erro ao salvar produto:", err);
               alert(`Não foi possível salvar o produto.`);
            });
        }

        function logout() {
            localStorage.clear();
            window.location.href = "/login";
        }
        
        window.onclick = function(event) {
            if (event.target == productModal) {
                closeModal('productModal');
            }
            if (event.target == confirmationModal) {
                closeModal('confirmationModal');
            }
        }
    </script>
</body>
</html>
