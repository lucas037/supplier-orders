<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Registrar</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #3a7bd5, #3a6073);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background-color: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0px 4px 12px rgba(0,0,0,0.2);
            width: 320px;
            text-align: center;
        }
        .login-container h2 {
            margin-bottom: 1.5rem;
            color: #333;
        }
        .login-container input,
        .login-container select {
            width: 100%;
            padding: 10px;
            margin: 0.5rem 0;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
            box-sizing: border-box;
        }
        .login-container button {
            width: 100%;
            padding: 10px;
            background-color: #3a7bd5;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 1rem;
        }
        .login-container button:hover {
            background-color: #305d9b;
        }
        .login-container button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        .register-link {
            display: block;
            margin-top: 1rem;
            font-size: 13px;
            color: #555;
            text-decoration: none;
            transition: 0.2s;
        }
        .register-link:hover {
            color: #3a7bd5;
            text-decoration: underline;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Criar Conta</h2>
        <form id="registerForm">
            <input type="text" id="name" name="name" placeholder="Nome" required>
            <input type="text" id="username" name="username" placeholder="Usuário" required>
            <input type="password" id="password" name="password" placeholder="Senha (mín. 6 caracteres)" required>
            
            <select id="role" name="role" required>
                <option value="" disabled selected>Selecione seu perfil</option>
                <option value="CLIENT">Cliente</option>
                <option value="SUPPLIER">Fornecedor</option>
            </select>

            <div id="clientFields" class="hidden">
                <input type="date" id="birthdate" name="birthdate" placeholder="Data de Nascimento">
                <input type="text" id="cpf" name="cpf" placeholder="CPF (11 dígitos)">
            </div>

            <div id="supplierFields" class="hidden">
                <input type="text" id="cnpj" name="cnpj" placeholder="CNPJ (14 dígitos)">
            </div>

            <button type="submit" id="registerButton">Registrar</button>
        </form>
        <a class="register-link" href="/login">Já tem uma conta? Entre aqui</a>
    </div>

    <script>
        const roleSelect = document.getElementById('role');
        const clientFields = document.getElementById('clientFields');
        const supplierFields = document.getElementById('supplierFields');
        const registerForm = document.getElementById('registerForm');
        const registerButton = document.getElementById('registerButton');

        let firstReqDone = false;
        let savedUsername = '';
        let savedId = '';
        let savedRole = '';

        roleSelect.addEventListener('change', () => {
            const role = roleSelect.value;
            clientFields.classList.toggle('hidden', role !== 'CLIENT');
            supplierFields.classList.toggle('hidden', role !== 'SUPPLIER');
            
            document.getElementById('birthdate').required = (role === 'CLIENT');
            document.getElementById('cpf').required = (role === 'CLIENT');
            document.getElementById('cnpj').required = (role === 'SUPPLIER');
        });

        function validateFields(data) {
            if (data.password.length < 6) {
                alert("A senha deve ter pelo menos 6 caracteres.");
                return false;
            }
            if (data.role === 'CLIENT' && data.cpf.length !== 11) {
                alert("O CPF deve conter exatamente 11 dígitos.");
                return false;
            }
            if (data.role === 'SUPPLIER' && data.cnpj.length !== 14) {
                alert("O CNPJ deve conter exatamente 14 dígitos.");
                return false;
            }
            return true;
        }

        registerForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            registerButton.disabled = true;

            const formData = new FormData(e.target);
            const data = Object.fromEntries(formData.entries());

            if (!validateFields(data)) {
                registerButton.disabled = false;
                return;
            }

            try {
                if (!firstReqDone || savedUsername !== data.username) {
                    const firstRequestBody = {
                        name: data.name,
                        username: data.username,
                        password: data.password,
                        role: data.role
                    };
                    
                    const res = await fetch('/api/v1/auth/register', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(firstRequestBody)
                    });

                    const resData = await res.json();
                    if (!res.ok) {
                        alert(resData.message || "Erro no registro. Verifique se o usuário já existe.");
                        throw new Error("Falha na primeira requisição");
                    }
                    
                    savedId = resData.id;
                    savedRole = resData.role;
                    savedUsername = data.username;
                    firstReqDone = true;
                }

                let secondUrl = '';
                let secondBody = {};

                if (savedRole === 'CLIENT') {
                    secondUrl = '/api/v1/client/register';
                    secondBody = { id: savedId, balance: 10, birthdate: data.birthdate, cpf: data.cpf };
                } else if (savedRole === 'SUPPLIER') {
                    secondUrl = '/api/v1/supplier/register';
                    secondBody = { id: savedId, cnpj: data.cnpj };
                }

                const secondRes = await fetch(secondUrl, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(secondBody)
                });

                if (!secondRes.ok) {
                    const secondData = await secondRes.json();
                    alert(secondData.message || `Erro ao registrar detalhes de ${savedRole.toLowerCase()}.`);
                    throw new Error("Falha na segunda requisição");
                }

                window.location.href = '/login';

            } catch (err) {
                console.error("Erro no processo de registro:", err);
                if (!err.message.includes("Falha")) {
                    alert("Ocorreu um erro inesperado. Tente novamente.");
                }
            } finally {
                registerButton.disabled = false;
            }
        });
    </script>
</body>
</html>