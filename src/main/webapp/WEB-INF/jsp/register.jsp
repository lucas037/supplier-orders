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
        .register-container {
            background-color: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0px 4px 12px rgba(0,0,0,0.2);
            width: 320px;
            text-align: center;
        }
        .register-container h2 {
            margin-bottom: 1.5rem;
            color: #333;
        }
        .register-container label {
            display: block;
            text-align: left;
            margin-top: 10px;
            font-weight: bold;
            font-size: 14px;
            color: #333;
        }
        .register-container input, 
        .register-container select {
            width: 100%;
            padding: 10px;
            margin: 0.5rem 0;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        .register-container button {
            width: 100%;
            padding: 10px;
            background-color: #3a7bd5;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 0.5rem;
        }
        .register-container button:hover {
            background-color: #305d9b;
        }
        .hidden {
            display: none;
        }
        
        .login-link {
            display: block;
            margin-top: 1rem;
            font-size: 13px;
            color: #555;
            text-decoration: none;
            transition: 0.2s;
        }
        .login-link:hover {
            color: #3a7bd5;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Registrar</h2>

        <label>Nome</label>
        <input type="text" id="name">

        <label>Username</label>
        <input type="text" id="username">

        <label>Password</label>
        <input type="password" id="password">

        <label>Role</label>
        <select id="role">
            <option value="">Selecione...</option>
            <option value="CLIENT">CLIENT</option>
            <option value="SUPPLIER">SUPPLIER</option>
        </select>

        <div id="clientFields" class="hidden">
            <label>Birthdate</label>
            <input type="date" id="birthdate">

            <label>CPF</label>
            <input type="text" id="cpf">
        </div>

        <div id="supplierFields" class="hidden">
            <label>CNPJ</label>
            <input type="text" id="cnpj">
        </div>

        <button onclick="register()">Registrar</button>
        
        <a class="login-link" href="/login">Possui conta? Login</a>

    </div>

    <script>
        const roleSelect = document.getElementById('role');
        const clientFields = document.getElementById('clientFields');
        const supplierFields = document.getElementById('supplierFields');

        roleSelect.addEventListener('change', () => {
            clientFields.classList.add('hidden');
            supplierFields.classList.add('hidden');
            if (roleSelect.value === 'CLIENT') {
                clientFields.classList.remove('hidden');
            } else if (roleSelect.value === 'SUPPLIER') {
                supplierFields.classList.remove('hidden');
            }
        });

        function validateFields(name, username, password, role) {
            if (!name.trim()) { alert("O nome é obrigatório."); return false; }
            if (!username.trim()) { alert("O username é obrigatório."); return false; }
            if (!password.trim() || password.length < 6) { alert("A senha deve ter pelo menos 6 caracteres."); return false; }
            if (!role) { alert("Selecione um papel (role)."); return false; }
            if (role === 'CLIENT') {
                const birthdate = document.getElementById('birthdate').value;
                const cpf = document.getElementById('cpf').value;
                if (!birthdate) { alert("A data de nascimento é obrigatória para clientes."); return false; }
                if (!cpf.trim() || cpf.length !== 11) { alert("O CPF deve conter 11 dígitos."); return false; }
            }
            if (role === 'SUPPLIER') {
                const cnpj = document.getElementById('cnpj').value;
                if (!cnpj.trim() || cnpj.length !== 14) { alert("O CNPJ deve conter 14 dígitos."); return false; }
            }
            return true;
        }

        async function register() {
            const name = document.getElementById('name').value;
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const role = roleSelect.value;

            if (!validateFields(name, username, password, role)) return;

            let body = { name, username, password, role };

            try {
                const res = await fetch('/api/v1/auth/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(body)
                });

                const resData = await res.json();
                if (!res.ok) {
                    alert(resData.message || "Erro no registro");
                    return;
                }

                localStorage.setItem('id', resData.id);
                localStorage.setItem('role', resData.role);

                let secondUrl = '';
                let secondBody = {};

                if (role === 'CLIENT') {
                    secondUrl = '/api/v1/client/register';
                    secondBody = {
                        id: resData.id,
                        balance: 10,
                        birthdate: document.getElementById('birthdate').value,
                        cpf: document.getElementById('cpf').value
                    };
                } else if (role === 'SUPPLIER') {
                    secondUrl = '/api/v1/supplier/register';
                    secondBody = {
                        id: resData.id,
                        cnpj: document.getElementById('cnpj').value
                    };
                }

                const secondRes = await fetch(secondUrl, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(secondBody)
                });

                const secondData = await secondRes.json();
                if (!secondRes.ok) {
                    alert(secondData.message || "Erro no registro de " + role.toLowerCase());
                    return;
                }

                window.location.href = '/login';

            } catch (err) {
                alert("Erro de conexão: " + err);
            }
        }
    </script>
</body>
</html>
