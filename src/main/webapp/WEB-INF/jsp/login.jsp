<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Login</title>
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
            width: 300px;
            text-align: center;
        }
        .login-container h2 {
            margin-bottom: 1.5rem;
            color: #333;
        }
        .login-container input {
            width: 100%;
            padding: 10px;
            margin: 0.5rem 0;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
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
            margin-top: 0.5rem;
        }
        .login-container button:hover {
            background-color: #305d9b;
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
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Entrar</h2>
        <form id="loginForm">
            <input type="text" name="username" placeholder="Usuário" required />
            <input type="password" name="password" placeholder="Senha" required />
            <button type="submit">Login</button>
        </form>
        <a class="register-link" href="/register">Não tem conta? Cadastre-se</a>
    </div>

    <script>
        document.getElementById("loginForm").addEventListener("submit", async function(e) {
            e.preventDefault();
            
            const username = e.target.username.value;
            const password = e.target.password.value;

            try {
                const response = await fetch(`api/v1/auth/login`, {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ username, password })
                });

                if (!response.ok) {
                    alert("Usuário ou senha inválidos!");
                    return;
                }

                const data = await response.json();
                console.log("Login bem-sucedido:", data);

                localStorage.setItem("token", data.token);
                localStorage.setItem("role", data.role);

                if (data.role === "CLIENT") {
                    window.location.href = "/buy-products";
                } else if (data.role === "SUPPLIER") {
                    window.location.href = "/products";
                } else {
                    alert("Erro ao resgatar cargo do usuário.");
                }

            } catch (error) {
                console.error("Erro no login:", error);
                alert("Erro ao tentar fazer login.");
            }
        });
    </script>
</body>
</html>
