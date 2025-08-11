<%@ page contentType="text/html;charset=UTF-8" isELIgnored="true" %>
<html>
<head>
    <title>Histórico de Transações</title>
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
        
        .container {
            background-color: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0px 4px 12px rgba(0,0,0,0.2);
            width: 90%;
            max-width: 1000px;
            text-align: center;
        }

        .container h2 {
            margin-bottom: 1.5rem;
            color: #333;
        }

        .header-actions {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            gap: 10px;
            margin-bottom: 1rem;
            flex-wrap: wrap;
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
            transition: background-color 0.3s;
        }
        .logout { background-color: crimson; }
        .logout:hover { background-color: darkred; }
        .nav-btn { background-color: #3498db; }
        .nav-btn:hover { background-color: #2980b9; }

        #transactions-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        #transactions-table th, #transactions-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
        }

        #transactions-table th {
            background-color: #3a7bd5;
            font-weight: bold;
            color: white;
        }

        #transactions-table tr:last-child td {
            border-bottom: none;
        }
        #transactions-table tr:hover {
            background-color: #f1f1f1;
        }

        .status-message {
            font-style: italic;
            color: #555;
            margin-top: 2rem;
            font-size: 1.1em;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            color: white;
            font-size: 0.85em;
            font-weight: bold;
            text-transform: uppercase;
        }
        .status-realizado { background-color: #ffc107; color: #333; }
        .status-finalizado { background-color: #28a745; }
        .status-cancelado { background-color: #dc3545; }
        .status-deposito { background-color: #17a2b8; }
        .status-default { background-color: #6c757d; }

    </style>
</head>
<body>
    <div class="container">
        <div class="header-actions">
            <button class="btn logout" onclick="logout()">Sair</button>
            <a href="/buy-products" class="btn nav-btn">Produtos</a>
            <a href="/deposit" class="btn nav-btn">Depósito</a>
            <a href="/cart" class="btn nav-btn">Carrinho</a>
        </div>

        <h2>Seu Histórico de Transações</h2>

        <div id="transactions-content">
             <p id="loading-message" class="status-message">Carregando suas transações...</p>
             <table id="transactions-table" style="display: none;">
                 <thead>
                     <tr>
                         <th>Data</th>
                         <th>Status</th>
                         <th>Produto</th>
                         <th id="party-header">Fornecedor</th>
                         <th>ID Pedido</th>
                     </tr>
                 </thead>
                 <tbody id="transactions-body">
                 </tbody>
             </table>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const token = localStorage.getItem("token");
            const role = localStorage.getItem("role");

            if (!token) {
                alert("Você precisa estar logado para ver seu histórico.");
                window.location.href = "/login";
                return;
            }
            
            const tableBody = document.getElementById('transactions-body');
            const loadingMessage = document.getElementById('loading-message');
            const table = document.getElementById('transactions-table');
            const partyHeader = document.getElementById('party-header');
            const headerActions = document.querySelector('.header-actions');

            if (role === 'SUPPLIER') {
                partyHeader.textContent = 'Cliente';
                headerActions.innerHTML = `
                    <button class="btn logout" onclick="logout()">Sair</button>
                    <a href="/products" class="btn nav-btn">Produtos</a>
                `;
            } else {
                partyHeader.textContent = 'Fornecedor';
            }

            const formatDateTime = (isoString) => {
                if (!isoString) return 'N/A';
                const safeIsoString = isoString.replace(/(\.\d{3})\d+/, '$1');
                const date = new Date(safeIsoString);
                if (isNaN(date.getTime())) {
                    return 'Data inválida';
                }
                const options = {
                    year: 'numeric', month: '2-digit', day: '2-digit',
                    hour: '2-digit', minute: '2-digit'
                };
                return date.toLocaleString('pt-BR', options);
            };

            const formatTransactionType = (type) => {
                let className = 'status-default';
                let text = 'Desconhecido';

                switch (type) {
                    case 'AGUARDANDO_PAGAMENTO':
                        className = 'status-realizado';
                        text = 'PEDIDO REALIZADO';
                        break;
                    case 'PAGO':
                        className = 'status-finalizado';
                        text = 'PEDIDO FINALIZADO';
                        break;
                    case 'CANCELADO':
                        className = 'status-cancelado';
                        text = 'CANCELADO';
                        break;
                    case 'DEPOSITO':
                        className = 'status-deposito';
                        text = 'DEPOSITO';
                        break;
                }
                
                return `<span class="status-badge ${className}">${text}</span>`;
            };

            const fetchTransactions = async () => {
                try {
                    const response = await fetch(`/api/v1/transaction`, {
                        headers: { "Authorization": "Bearer " + token }
                    });

                    if (!response.ok) {
                        throw new Error(`Falha ao buscar as transações (Status: ${response.status}).`);
                    }

                    const transactions = await response.json();
                    renderTransactions(transactions);

                } catch (error) {
                    loadingMessage.textContent = "Erro ao carregar seu histórico. Tente novamente mais tarde.";
                    console.error("Erro:", error);
                }
            };

            const renderTransactions = (transactions) => {
                tableBody.innerHTML = '';

                if (!transactions || transactions.length === 0) {
                    loadingMessage.textContent = "Nenhuma transação encontrada no seu histórico.";
                    table.style.display = 'none';
                    loadingMessage.style.display = 'block';
                } else {
                    loadingMessage.style.display = 'none';
                    table.style.display = 'table';

                    transactions.sort((a, b) => {
                        const dateA = new Date(a.transationDate.replace(/(\.\d{3})\d+/, '$1'));
                        const dateB = new Date(b.transationDate.replace(/(\.\d{3})\d+/, '$1'));
                        return dateB - dateA;
                    });

                    transactions.forEach(tx => {
                        const row = document.createElement('tr');
                        const partyName = role === 'SUPPLIER' ? tx.clientName : tx.supplierName;
                        
                        row.innerHTML = `
                            <td>${formatDateTime(tx.transationDate)}</td>
                            <td>${formatTransactionType(tx.transationType)}</td>
                            <td>${tx.productName || 'N/A'}</td>
                            <td>${partyName || 'N/A'}</td>
                            <td>${tx.orderId || 'N/A'}</td>
                        `;

                        tableBody.appendChild(row);
                    });
                }
            };

            fetchTransactions();
        });

        function logout() {
            localStorage.clear();
            window.location.href = "/login";
        }
    </script>
</body>
</html>
