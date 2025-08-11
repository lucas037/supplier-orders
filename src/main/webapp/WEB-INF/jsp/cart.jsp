<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Meu Carrinho</title>
    <style>
        /* Estilos base (iguais aos das outras telas) */
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            display: flex;
            justify-content: center;
            align-items: flex-start; /* Alinhado ao topo para carrinhos grandes */
            min-height: 100vh;
            margin: 0;
            padding: 2rem 0; /* Espaçamento vertical */
        }
        
        /* Container principal para o carrinho */
        .cart-container {
            background-color: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0px 4px 12px rgba(0,0,0,0.2);
            width: 90%;
            max-width: 900px; /* Largura máxima para a tabela */
            text-align: center;
        }

        .cart-container h2 {
            margin-bottom: 1.5rem;
            color: #333;
        }

        /* Estilos da tabela de pedidos */
        #orders-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        #orders-table th, #orders-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        #orders-table th {
            background-color: #f4f6f8;
            font-weight: bold;
            color: #333;
        }

        #orders-table tr:last-child td {
            border-bottom: none;
        }

        /* Botões de ação dentro da tabela */
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
            background-color: #28a745; /* Verde para pagar */
        }
        .btn-pay:hover {
            background-color: #218838;
        }

        .btn-cancel {
            background-color: #dc3545; /* Vermelho para cancelar */
        }
        .btn-cancel:hover {
            background-color: #c82333;
        }
        
        /* Mensagens de estado */
        .status-message {
            font-style: italic;
            color: #555;
            margin-top: 2rem;
        }

        /* Estilo para o Modal */
        .modal {
            display: none; /* Oculto por padrão */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5); /* Fundo escuro semitransparente */
            justify-content: center;
            align-items: center;
        }

        .modal.active {
            display: flex; /* Exibido com flexbox para centralizar */
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
        <h2>Meu Carrinho de Pedidos</h2>
        <div id="orders-content">
             <p id="loading-message" class="status-message">Carregando seus pedidos...</p>
             <table id="orders-table" style="display: none;">
                <thead>
                    <tr>
                        <th>Produto (ID)</th>
                        <th>Quantidade</th>
                        <th>Status</th>
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

            // Se não houver token, redireciona para a página de login
            if (!token) {
                alert("Você precisa estar logado para ver seus pedidos.");
                window.location.href = "/login";
                return;
            }
            
            const table = document.getElementById('orders-table');
            const tableBody = document.getElementById('orders-body');
            const loadingMessage = document.getElementById('loading-message');
            const modal = document.getElementById('confirmation-modal');
            const modalText = document.getElementById('modal-text');
            const closeModalButton = document.querySelector('.close-button');

            const fetchOrders = async () => {
                try {
                    const response = await fetch(`api/v1/order`, {
                        headers: { "Authorization": "Bearer " + token }
                    });

                    if (!response.ok) {
                        throw new Error("Falha ao buscar os pedidos.");
                    }

                    const orders = await response.json();
                    renderOrders(orders);

                } catch (error) {
                    loadingMessage.textContent = "Erro ao carregar seus pedidos. Tente novamente mais tarde.";
                    console.error("Erro:", error);
                }
            };

            const renderOrders = (orders) => {
                tableBody.innerHTML = ''; // Limpa a tabela antes de renderizar

                if (orders.length === 0) {
                    loadingMessage.textContent = "Seu carrinho está vazio.";
                    table.style.display = 'none';
                } else {
                    loadingMessage.style.display = 'none';
                    table.style.display = 'table';

                    orders.forEach(order => {
                        const row = document.createElement('tr');
                        
                        // Célula do Produto
                        const cellProduct = document.createElement('td');
                        cellProduct.textContent = order.productId;
                        row.appendChild(cellProduct);

                        // Célula da Quantidade
                        const cellQuant = document.createElement('td');
                        cellQuant.textContent = order.quant;
                        row.appendChild(cellQuant);

                        // Célula do Status
                        const cellStatus = document.createElement('td');
                        cellStatus.textContent = order.status.replace('_', ' ');
                        row.appendChild(cellStatus);

                        // Célula das Ações
                        const cellActions = document.createElement('td');
                        if (order.status === 'AGUARDANDO_PAGAMENTO') {
                            // Botão Pagar
                            const payButton = document.createElement('button');
                            payButton.textContent = 'Pagar Agora';
                            payButton.className = 'action-button btn-pay';
                            payButton.dataset.orderId = order.id; // Armazena o ID do pedido no botão
                            cellActions.appendChild(payButton);
                            
                            // Botão Cancelar
                            const cancelButton = document.createElement('button');
                            cancelButton.textContent = 'Cancelar Pedido';
                            cancelButton.className = 'action-button btn-cancel';
                            cancelButton.dataset.orderId = order.id;
                            cellActions.appendChild(cancelButton);
                        } else {
                            cellActions.textContent = '—'; // Sem ações para outros status
                        }
                        row.appendChild(cellActions);

                        tableBody.appendChild(row);
                    });
                }
            };

            const updateOrderStatus = async (orderId, newStatus) => {
                try {
                    const response = await fetch(`api/v1/order/update`, {
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
                    fetchOrders(); // Atualiza a lista após a ação
                    
                } catch (error) {
                    alert(`Erro: ${error.message}`);
                    console.error('Erro ao atualizar status:', error);
                }
            };
            
            // Função para exibir o modal
            const showModal = (message) => {
                modalText.textContent = message;
                modal.classList.add('active');
            };
            
            // Função para fechar o modal
            const hideModal = () => {
                modal.classList.remove('active');
            };

            // Adiciona um único 'event listener' na tabela para gerenciar cliques nos botões
            tableBody.addEventListener('click', (e) => {
                const target = e.target;
                const orderId = target.dataset.orderId;

                if (!orderId) return;

                if (target.classList.contains('btn-pay')) {
                    if (confirm(`Deseja confirmar o pagamento para o pedido do produto ${orderId}?`)) {
                        updateOrderStatus(parseInt(orderId), 'PAGO');
                    }
                } else if (target.classList.contains('btn-cancel')) {
                     if (confirm(`Tem certeza que deseja cancelar o pedido do produto ${orderId}?`)) {
                        updateOrderStatus(parseInt(orderId), 'CANCELADO');
                    }
                }
            });

            // Event listeners para fechar o modal
            closeModalButton.addEventListener('click', hideModal);
            modal.addEventListener('click', (e) => {
                if (e.target === modal) { // Fecha se clicar fora do conteúdo
                    hideModal();
                }
            });

            // Inicia o processo buscando os pedidos
            fetchOrders();
        });
    </script>
</body>
</html>