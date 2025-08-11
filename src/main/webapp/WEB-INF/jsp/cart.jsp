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

        .btn { display: inline-block; padding: 10px 20px; color: white; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; text-align: center; font-size: 14px; }
        .logout { background-color: crimson; }
        .logout:hover { background-color: darkred; }
        .products-btn { background-color: #3498db; }
        .products-btn:hover { background-color: #2980b9; }

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
            background-color: #3a7bd5;
            font-weight: bold;
            color: white;
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
            <a href="/deposit" class="btn products-btn">Depósito</a>
            <a href="/transaction-history" class="btn products-btn">Histórico</a>
        </div>
        <h2>Meu Carrinho de Pedidos</h2>
        <div id="orders-content">
             <p id="loading-message" class="status-message">Carregando seus pedidos...</p>
             <table id="orders-table" style="display: none;">
                 <thead>
                     <tr>
                         <th>Produto</th>
                         <th>Preço</th>
                         <th>Preço (Desc.)</th>
                         <th>Quant.</th>
                         <th>Preço Final</th>
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
            <div id="modal-text"></div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const token = localStorage.getItem("token");
            let orders = [];

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

                    orders = await response.json();
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

                        const cellDiscountPrice = document.createElement('td');
                        cellDiscountPrice.textContent = formatCurrency((1-order.discount)*order.price);
                        row.appendChild(cellDiscountPrice);

                        const cellQuant = document.createElement('td');
                        cellQuant.textContent = order.quant;
                        row.appendChild(cellQuant);

                        const cellTotalPrice = document.createElement('td');
                        cellTotalPrice.textContent = formatCurrency((1-order.discount)*order.price*order.quant);
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
                    showModal(`Erro ao atualizar o pedido: ${error.message}`);
                    console.error('Erro ao atualizar status:', error);
                }
            };

            const processPayment = async (orderId) => {
                modalText.innerHTML = '<h3>Processando Pagamento...</h3><p>Aguarde um instante, por favor.</p>';

                try {
                    const response = await fetch(`/api/v1/order/update`, {
                        method: "POST",
                        headers: { "Content-Type": "application/json", "Authorization": "Bearer " + token },
                        body: JSON.stringify({ id: orderId, status: 'PAGO' })
                    });

                    if (!response.ok) {
                        const errorData = await response.json();
                        throw new Error(errorData.message || 'Não foi possível processar o pagamento.');
                    }

                    modalText.innerHTML =
                        '<h3>Pagamento Confirmado! ✅</h3>' +
                        '<p>Sua compra foi realizada com sucesso.</p>' +
                        '<div style="margin-top: 20px;">' +
                        '<button id="closeSuccessModal" class="btn" style="background-color: #28a745;">Ótimo!</button>' +
                        '</div>';
                    document.getElementById('closeSuccessModal').addEventListener('click', hideModal);


                } catch (error) {
                    modalText.innerHTML =
                        '<h3>Ocorreu um Erro 😟</h3>' +
                        `<p style="margin: 15px 0;">${error.message}</p>` +
                        '<div style="margin-top: 20px;">' +
                        '<button id="closeErrorModal" class="btn" style="background-color: #dc3545;">Fechar</button>' +
                        '</div>';
                    document.getElementById('closeErrorModal').addEventListener('click', hideModal);
                    console.error('Erro ao processar pagamento:', error);
                }
            };
            
            const showModal = (message) => {
                modalText.innerHTML = `<p>${message}</p>`;
                modal.classList.add('active');
            };

            const showPaymentModal = async (orderId, orderPrice, orderQuant) => {
                try {
                    const currentBalance = await getClientBalance();
                    const totalPrice = orderPrice * orderQuant;

                    if (totalPrice > currentBalance) {
                        const modalContent =
                            '<h3>Saldo Insuficiente 😟</h3>' +
                            '<div style="text-align: left; margin: 20px 0;">' +
                            '<p><strong>Seu Saldo Atual:</strong> ' + formatCurrency(currentBalance) + '</p>' +
                            '<p><strong>Total da Compra:</strong> ' + formatCurrency(totalPrice) + '</p>' +
                            '<p style="color: #dc3545; font-weight: bold; margin-top: 15px;">Você não tem saldo suficiente para concluir esta transação.</p>' +
                            '</div>' +
                            '<p>Por favor, <a href="/deposit">faça um depósito</a> e tente novamente.</p>' +
                            '<div style="margin-top: 20px;">' +
                            '<button id="closeInsufficientFunds" class="btn" style="background-color: #6c757d;">Fechar</button>' +
                            '</div>';

                        modalText.innerHTML = modalContent;
                        modal.classList.add('active');
                        document.getElementById('closeInsufficientFunds').addEventListener('click', hideModal);

                    } else {
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
                                '<button id="confirmPayment" class="btn" style="background-color: #28a745; margin-right: 10px;">Confirmar Pagamento</button>' +
                                '<button id="cancelPayment" class="btn" style="background-color: #dc3545;">Cancelar</button>' +
                            '</div>';

                        modalText.innerHTML = modalContent;
                        modal.classList.add('active');

                        document.getElementById('confirmPayment').addEventListener('click', () => {
                            processPayment(parseInt(orderId));
                        });

                        document.getElementById('cancelPayment').addEventListener('click', () => {
                            hideModal();
                        });
                    }
                } catch (error) {
                    showModal('Erro ao obter informações de saldo: ' + error.message);
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
                    const order = orders.find(o => o.id == orderId);
                    if (order) {
                        const discountPrice = (1-order.discount)*order.price;
                        showPaymentModal(orderId, discountPrice, order.quant);
                    } else {
                        showModal('Erro: Não foi possível encontrar os dados do pedido.');
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