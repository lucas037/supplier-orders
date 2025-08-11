<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isELIgnored="true" %>
<html>
<head>
    <title>Lista de Produtos</title>
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

        #productsTable th:nth-child(3),
        #productsTable td:nth-child(3) {
            text-align: right;
        }

        #productsTable th:last-child,
        #productsTable td:last-child {
            text-align: center;
        }

        tr:hover { background-color: #f1f1f1; }
        
        .btn { display: inline-block; margin-bottom: 1rem; padding: 8px 12px; color: white; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; text-align: center; }
        .logout { background-color: crimson; }
        .logout:hover { background-color: darkred; }
        .add-btn { background-color: royalblue; }
        .add-btn:hover { background-color: navy; }

        .action-btn { padding: 5px 10px; margin: 2px; }
        .edit-btn { background-color: #ffc107; }
        .edit-btn:hover { background-color: #e0a800; }
        .delete-btn { background-color: #dc3545; }
        .delete-btn:hover { background-color: #c82333; }
        
        .modal { display: none; position: fixed; z-index: 100; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.6); }
        .modal-content { background-color: #fefefe; margin: 10% auto; padding: 25px; border-radius: 8px; width: 80%; max-width: 400px; color: black; position: relative; }
        .modal-content input[type="text"], .modal-content input[type="number"] { width: calc(100% - 16px); padding: 8px; margin: 8px 0; border: 1px solid #ccc; border-radius: 4px;}
        .modal-buttons { margin-top: 15px; display: flex; justify-content: flex-end; gap: 10px; }
        .modal-buttons .btn { margin-bottom: 0; }
        .save-btn { background-color: green; }
        .save-btn:hover { background-color: darkgreen; }
        .close-btn { background-color: gray; }
        .close-btn:hover { background-color: dimgray; }
    </style>
</head>
<body>
    <div class="container">
        <div>
            <button class="btn logout" onclick="logout()">Sair</button>
            <button class="btn add-btn" onclick="openAddModal()">+ Adicionar Produto</button>
        </div>
        <h1>Seus Produtos</h1>

        <table id="productsTable">
            <thead>
                <tr>
                    <th>Nome</th>
                    <th>Descrição</th>
                    <th>Preço</th>
                    <th>Desconto</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <div id="productModal" class="modal">
        <div class="modal-content">
            <h3 id="modalTitle"></h3>
            <input type="hidden" id="productId" />
            <input type="text" id="name" placeholder="Nome do Produto" required/>
            <input type="text" id="description" placeholder="Descrição" required/>
            <input type="number" id="price" placeholder="Preço" step="0.01" required/>
            
            <div style="margin-top: 15px; text-align: left;">
                <label>Desconto:</label>
                <div style="margin-top: 5px;">
                    <input type="radio" id="discount0" name="discount" value="0.00">
                    <label for="discount0" style="margin-right: 10px;">0%</label>
                    <input type="radio" id="discount5" name="discount" value="0.05">
                    <label for="discount5" style="margin-right: 10px;">5%</label>
                    <input type="radio" id="discount10" name="discount" value="0.10">
                    <label for="discount10" style="margin-right: 10px;">10%</label>
                    <input type="radio" id="discount15" name="discount" value="0.15">
                    <label for="discount15" style="margin-right: 10px;">15%</label>
                    <input type="radio" id="discount25" name="discount" value="0.25">
                    <label for="discount25">25%</label>
                </div>
            </div>

            <div class="modal-buttons">
                <button class="btn close-btn" onclick="closeModal()">Cancelar</button>
                <button id="saveBtn" class="btn save-btn" onclick="handleSave()">Salvar</button>
            </div>
        </div>
    </div>

    <script>
        const token = localStorage.getItem("token");
        const modal = document.getElementById("productModal");
        let productsData = [];

        if (!token) {
            alert("Token não encontrado! Faça login novamente.");
            window.location.href = "/login";
        } else {
            loadProducts();
        }

        function loadProducts() {
            fetch("/api/v1/product/supplier", {
                method: "GET",
                headers: { "Authorization": "Bearer " + token }
            })
            .then(response => response.ok ? response.json() : Promise.reject(response))
            .then(data => {
                productsData = Array.isArray(data) ? data : (data.content || []);
                const tbody = document.querySelector("#productsTable tbody");
                tbody.innerHTML = "";
                productsData.forEach(product => {
                    const priceFormatted = `R$ ${Number(product.price || 0).toFixed(2)}`;
                    const discountFormatted = `${(product.discount || 0) * 100}%`;
                    tbody.innerHTML += `
                        <tr id="row-${product.id}">
                            <td>${product.name}</td>
                            <td>${product.description}</td>
                            <td>${priceFormatted}</td>
                            <td>${discountFormatted}</td>
                            <td>
                                <button class="btn action-btn edit-btn" onclick="openEditModal(${product.id})">Editar</button>
                                <button class="btn action-btn delete-btn" onclick="deleteProduct(${product.id})">Remover</button>
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
        
        function deleteProduct(id) {
            if (!confirm(`Tem certeza que deseja remover este produto?`)) {
                return;
            }
            fetch(`/api/v1/product/delete/${id}`, {
                method: "DELETE",
                headers: { "Authorization": "Bearer " + token }
            })
            .then(response => {
                if (!response.ok) return Promise.reject(response);
                loadProducts();
            })
            .catch(err => {
                console.error("Erro ao remover produto:", err);
                alert("Não foi possível remover o produto.");
            });
        }

        function openAddModal() {
            document.getElementById("modalTitle").innerText = "Adicionar Novo Produto";
            document.getElementById("productId").value = "";
            document.getElementById("name").value = "";
            document.getElementById("description").value = "";
            document.getElementById("price").value = "";
            document.getElementById("discount0").checked = true;
            modal.style.display = "block";
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
                document.getElementById("discount0").checked = true; // Fallback
            }

            modal.style.display = "block";
        }
        
        function closeModal() {
            modal.style.display = "none";
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
                closeModal();
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
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>