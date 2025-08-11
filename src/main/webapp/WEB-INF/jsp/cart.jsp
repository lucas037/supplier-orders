<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Meu Carrinho</title>
    <style>
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
        
        .cart-container {
            background-color: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0px 4px 12px rgba(0,0,0,0.2);
            width: 90%;
            max-width: 900px;
            text-align: center;
        }

        .cart-container h2 {
            margin-bottom: 1.5rem;
            color: #333;
        }

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
        .products-btn { background-color: #ff9800; }
        .products-btn:hover { background-color: #f57c00; }

        #orders-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        #orders-table th, #orders-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
        }

        #orders-table th {
            background-color: #f4f6f8;
            font-weight: bold;
            color: #333;
        }

        #orders-table tr:last-child td {
            border-bottom: none;
        }

        .action-button {
            padding: 6px 12px;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            transition: 0.3s;
            margin-right: 5px;
        }

        .btn-pay {
            background-color: #28a745;
        }
        .btn-pay:hover {
            background-color: #218838;
        }

        .btn-cancel {
            background-color: #dc3545;
        }
        .btn-cancel:hover {
            background-color: #c82333;
        }
        
        .status-message {
            font-style: italic;
            color: #555;
            margin-top: 2rem;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background-color: #fff;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            text-align: center;
            width: 90%;
            max-width: 400px;
            position: relative;
        }
        
        .close-button {
            color: #aaa;
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close-button:hover {
            color: #333;
        }
    </style>
</head>
<body>
    <div class="cart-container">
        <div class="header-actions">
            <button class="btn logout" onclick="logout()">Sair</button>
            <a href="/buy-products" class="btn products-btn">Produtos</a>
        </div>
        <h2>Meu Carrinho de Pedidos</h2>
        <div id="orders-content">
             <p id="loading-message" class="status-message">Carregando seus pedidos...</p>
             <table id="orders-table" style="display: none;">
                <thead>
                    <tr>
                        <th>Produto</th>
                        <th>Preço</th>
                        <th>Quantidade</th>
                        <th>Preço Total</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody id="orders-body">
                </tbody>
            </table>
        </div>
    </div>

    <div id="confirmation-modal" class="modal">
        <div class="modal-content">
            <span class="close-button">&times;</span>
            <p id="modal-text"></p>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const token = localStorage.getItem("token");
            let orders = []; // Variável global para armazenar as orders

            if (!token) {
                alert("Você precisa estar logado para ver seus pedidos.");
                window.location.href = "/login";
                return;
            }
            
            const tableBody = document.getElementById('orders-body');
            const loadingMessage = document.getElementById('loading-message');
            const table = document.getElementById('orders-table');
            const modal = document.getElementById('confirmation-modal');
            const modalText = document.getElementById('modal-text');
            const closeModalButton = document.querySelector('.close-button');

            const formatCurrency = (value) => {
                return Number(value).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
            };

            const fetchOrders = async () => {
                try {
                    const response = await fetch(`/api/v1/order`, {
                        headers: { "Authorization": "Bearer " + token }
                    });

                    if (!response.ok) {
                        throw new Error("Falha ao buscar os pedidos.");
                    }

                    orders = await response.json(); // Armazena na variável global
                    renderOrders(orders);

                } catch (error) {
                    loadingMessage.textContent = "Erro ao carregar seus pedidos. Tente novamente mais tarde.";
                    console.error("Erro:", error);
                }
            };

            const renderOrders = (orders) => {
                tableBody.innerHTML = '';

                if (orders.length === 0) {
                    loadingMessage.textContent = "Seu carrinho está vazio.";
                    table.style.display = 'none';
                    loadingMessage.style.display = 'block';
                } else {
                    loadingMessage.style.display = 'none';
                    table.style.display = 'table';

                    orders.forEach(order => {
                        const row = document.createElement('tr');
                        
                        const cellProduct = document.createElement('td');
                        cellProduct.textContent = order.productName;
                        row.appendChild(cellProduct);

                        const cellPrice = document.createElement('td');
                        cellPrice.textContent = formatCurrency(order.price);
                        row.appendChild(cellPrice);

                        const cellQuant = document.createElement('td');
                        cellQuant.textContent = order.quant;
                        row.appendChild(cellQuant);

                        const cellTotalPrice = document.createElement('td');
                        cellTotalPrice.textContent = formatCurrency(order.price*order.quant);
                        row.appendChild(cellTotalPrice);

                        const cellActions = document.createElement('td');
                        if (order.status === 'AGUARDANDO_PAGAMENTO') {
                            const payButton = document.createElement('button');
                            payButton.textContent = 'Pagar Agora';
                            payButton.className = 'action-button btn-pay';
                            payButton.dataset.orderId = order.id;
                            cellActions.appendChild(payButton);
                            
                            const cancelButton = document.createElement('button');
                            cancelButton.textContent = 'Cancelar Pedido';
                            cancelButton.className = 'action-button btn-cancel';
                            cancelButton.dataset.orderId = order.id;
                            cellActions.appendChild(cancelButton);
                        } else {
                            cellActions.textContent = '—';
                        }
                        row.appendChild(cellActions);

                        tableBody.appendChild(row);
                    });
                }
            };

            const getClientBalance = async () => {
                try {
                    const response = await fetch(`/api/v1/client/balance`, {
                        method: "GET",
                        headers: {
                            "Authorization": "Bearer " + token
                        }
                    });
                    
                    if (!response.ok) {
                        throw new Error('Não foi possível obter o saldo.');
                    }
                    
                    const data = await response.json();
                    return data.balance;
                } catch (error) {
                    console.error('Erro ao obter saldo:', error);
                    throw error;
                }
            };

            const updateOrderStatus = async (orderId, newStatus) => {
                try {
                    const response = await fetch(`/api/v1/order/update`, {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                            "Authorization": "Bearer " + token
                        },
                        body: JSON.stringify({ id: orderId, status: newStatus })
                    });
                    
                    if (!response.ok) {
                       const errorData = await response.json();
                       throw new Error(errorData.message || 'Não foi possível atualizar o pedido.');
                    }
                    
                    const message = newStatus === 'PAGO' ? 'Pagamento confirmado com sucesso!' : 'Pedido cancelado com sucesso!';
                    showModal(message);
                    fetchOrders();
                    
                } catch (error) {
                    alert(`Erro: ${error.message}`);
                    console.error('Erro ao atualizar status:', error);
                }
            };
            
            const showModal = (message) => {
                modalText.textContent = message;
                modal.classList.add('active');
            };

            const showPaymentModal = async (orderId, orderPrice, orderQuant) => {
                try {
                    const currentBalance = await getClientBalance();
                    const totalPrice = orderPrice * orderQuant;
                    const finalBalance = currentBalance - totalPrice;

                    const modalContent = 
                        '<h3>Confirmação de Pagamento</h3>' +
                        '<div style="text-align: left; margin: 20px 0;">' +
                            '<p><strong>Saldo Atual:</strong> ' + formatCurrency(currentBalance) + '</p>' +
                            '<p><strong>Preço Unitário:</strong> ' + formatCurrency(orderPrice) + '</p>' +
                            '<p><strong>Quantidade:</strong> ' + orderQuant + '</p>' +
                            '<p><strong>Total a Pagar:</strong> ' + formatCurrency(totalPrice) + '</p>' +
                            '<p><strong>Saldo Final:</strong> ' + formatCurrency(finalBalance) + '</p>' +
                        '</div>' +
                        '<div style="margin-top: 20px;">' +
                            '<button id="confirmPayment" style="background-color: #28a745; color: white; border: none; padding: 10px 20px; border-radius: 5px; margin-right: 10px; cursor: pointer;">Confirmar Pagamento</button>' +
                            '<button id="cancelPayment" style="background-color: #dc3545; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;">Cancelar</button>' +
                        '</div>';

                    modalText.innerHTML = modalContent;
                    modal.classList.add('active');

                    // Adicionar event listeners para os botões
                    document.getElementById('confirmPayment').addEventListener('click', () => {
                        hideModal();
                        updateOrderStatus(parseInt(orderId), 'PAGO');
                    });

                    document.getElementById('cancelPayment').addEventListener('click', () => {
                        hideModal();
                    });

                } catch (error) {
                    alert('Erro ao obter informações de saldo: ' + error.message);
                }
            };
            
            const hideModal = () => {
                modal.classList.remove('active');
            };

            tableBody.addEventListener('click', (e) => {
                const target = e.target;
                const orderId = target.dataset.orderId;

                if (!orderId) return;

                if (target.classList.contains('btn-pay')) {
                    // Encontrar a ordem correspondente para obter preço e quantidade
                    const order = orders.find(o => o.id == orderId);
                    if (order) {
                        showPaymentModal(orderId, order.price, order.quant);
                    } else {
                        alert('Erro: Não foi possível encontrar os dados do pedido.');
                    }
                } else if (target.classList.contains('btn-cancel')) {
                     if (confirm(`Tem certeza que deseja cancelar o pedido ${orderId}?`)) {
                        updateOrderStatus(parseInt(orderId), 'CANCELADO');
                    }
                }
            });

            closeModalButton.addEventListener('click', hideModal);
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    hideModal();
                }
            });

            fetchOrders();
        });

        function logout() {
            localStorage.clear();
            window.location.href = "/login";
        }
    </script>
</body>
</html>