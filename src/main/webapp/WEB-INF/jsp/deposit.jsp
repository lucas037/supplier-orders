<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page isELIgnored="true" %>
<html>
<head>
    <title>Depósito</title>
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
            max-width: 600px;
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
        }

        .logout {
            background-color: crimson;
        }
        .logout:hover {
            background-color: darkred;
        }

        .nav-btn {
            background-color: #3498db;
        }
        .nav-btn:hover {
            background-color: #2980b9;
        }

        .deposit-btn {
            background-color: #28a745;
            font-size: 1.1em;
            padding: 12px 24px;
        }
        .deposit-btn:hover {
            background-color: #218838;
        }

        .balance-section {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            border: 1px solid #dee2e6;
        }

        .balance-section h3 {
            margin: 0 0 0.5rem 0;
            color: #333;
            font-size: 1.1em;
        }

        #currentBalance {
            font-size: 2.5em;
            font-weight: bold;
            color: #28a745;
            margin: 0;
        }

        #depositAmount {
            width: calc(100% - 40px);
            padding: 15px 20px;
            margin-bottom: 1.5rem;
            border-radius: 8px;
            border: 2px solid #ddd;
            font-size: 1.2em;
            text-align: center;
            box-sizing: border-box;
        }

        #depositAmount:focus {
            outline: none;
            border-color: #3a7bd5;
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

        .modal-buttons {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .confirm-btn {
            background-color: #28a745;
        }
        .confirm-btn:hover {
            background-color: #218838;
        }

        .cancel-btn {
            background-color: #6c757d;
        }
        .cancel-btn:hover {
            background-color: #5a6268;
        }

        #confirmAmount {
            font-weight: bold;
            font-size: 1.2em;
            color: #333;
        }

        #notification {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background-color: #28a745;
            color: white;
            padding: 15px 25px;
            border-radius: 8px;
            z-index: 2000;
            display: none;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            font-size: 1.1em;
        }

        #notification.error {
            background-color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-actions">
            <button class="btn logout" onclick="logout()">Sair</button>
            <a href="/buy-products" class="btn nav-btn">Produtos</a>
            <a href="/cart" class="btn nav-btn">Carrinho</a>
            <a href="/transaction-history" class="btn nav-btn">Histórico</a>
        </div>

        <h2>Área de Depósito</h2>

        <div class="balance-section">
            <h3>Seu Saldo Atual</h3>
            <div id="currentBalance">R$ 0,00</div>
        </div>

        <div>
            <input type="number" id="depositAmount" placeholder="Digite o valor (mín. R$ 10)" min="10" step="0.01">
            <button class="btn deposit-btn" onclick="initiateDeposit()">Depositar</button>
        </div>
    </div>

    <!-- Modal de Confirmação -->
    <div id="confirmationModal" class="modal">
        <div class="modal-content">
            <h3>Confirmar Depósito</h3>
            <p>Você deseja depositar <span id="confirmAmount"></span>?</p>
            <div class="modal-buttons">
                <button class="btn cancel-btn" onclick="closeModal()">Cancelar</button>
                <button class="btn confirm-btn" onclick="processDeposit()">Confirmar</button>
            </div>
        </div>
    </div>

    <!-- Notificação de Sucesso/Erro -->
    <div id="notification"></div>

    <script>
        const token = localStorage.getItem("token");
        const modal = document.getElementById("confirmationModal");
        const notification = document.getElementById("notification");
        let depositValue = 0;

        // Verifica se o token existe, senão redireciona para o login
        if (!token) {
            showNotification("Token não encontrado! Redirecionando para o login...", true);
            setTimeout(() => {
                window.location.href = "/login";
            }, 2000);
        } else {
            loadBalance();
        }

        /**
         * Carrega o saldo do usuário da API.
         */
        function loadBalance() {
            fetch("/api/v1/client/balance", {
                method: "GET",
                headers: { "Authorization": "Bearer " + token }
            })
            .then(response => {
                if (!response.ok) {
                    return Promise.reject(`Erro ${response.status}: Não foi possível carregar o saldo.`);
                }
                return response.json();
            })
            .then(data => {
                const balance = data.balance || 0;
                document.getElementById("currentBalance").innerText = `R$ ${Number(balance).toFixed(2).replace('.', ',')}`;
            })
            .catch(error => {
                console.error("Erro ao carregar saldo:", error);
                showNotification(error.toString(), true);
            });
        }

        /**
         * Inicia o processo de depósito, validando o valor e abrindo o modal.
         */
        function initiateDeposit() {
            const amountInput = document.getElementById("depositAmount");
            const amount = parseFloat(amountInput.value);

            if (isNaN(amount) || amount < 10) {
                showNotification("Por favor, insira um valor de no mínimo R$ 10,00.", true);
                return;
            }

            depositValue = amount;
            document.getElementById("confirmAmount").innerText = `R$ ${amount.toFixed(2).replace('.', ',')}`;
            modal.classList.add("active"); // Adiciona a classe active para mostrar o modal
        }

        /**
         * Processa o depósito enviando a requisição para a API.
         */
        function processDeposit() {
            closeModal();
            fetch("/api/v1/client/deposit", {
                method: "POST",
                headers: {
                    "Authorization": "Bearer " + token,
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ value: depositValue })
            })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => Promise.reject(`Erro: ${text || 'Não foi possível completar o depósito.'}`));
                }
                return response.json();
            })
            .then(data => {
                showNotification("Depósito realizado com sucesso!");
                document.getElementById("depositAmount").value = "";
                loadBalance(); // Recarrega o saldo para exibir o novo valor
            })
            .catch(error => {
                console.error("Erro ao depositar:", error);
                showNotification(error.toString(), true);
            });
        }

        /**
         * Exibe uma notificação na tela.
         * @param {string} message - A mensagem a ser exibida.
         * @param {boolean} isError - Se a notificação é de erro.
         */
        function showNotification(message, isError = false) {
            notification.textContent = message;
            notification.className = isError ? 'error' : '';
            notification.style.display = 'block';

            setTimeout(() => {
                notification.style.display = 'none';
            }, 3000);
        }

        function closeModal() {
            modal.classList.remove("active");
        }

        function logout() {
            localStorage.clear();
            window.location.href = "/login";
        }

        // Fecha o modal se o usuário clicar fora dele
        window.onclick = function(event) {
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>
