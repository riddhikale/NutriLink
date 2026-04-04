import { useState } from "react";
import "../styles/login.css";

function Login() {
  const [phone, setPhone] = useState("");
  const [pin, setPin] = useState("");

  async function handleLogin() {
    try {
      const res = await fetch("http://localhost:8080/api/auth/login-test", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ phone, pin }),
      });

      const data = await res.json();

      if (data.success) {
        localStorage.setItem("token", data.token);
        localStorage.setItem("user", JSON.stringify(data.user));
        window.location.href = "/dashboard";
      } else {
        alert(data.message);
      }
    } catch (err) {
      alert("Login failed");
    }
  }

  return (
    <div className="login-container">
      
      {/* LEFT SIDE (BRANDING) */}
      <div className="login-left">
        <h1>NutriLink</h1>
        <p>Supervisor Monitoring System</p>
      </div>

      {/* RIGHT SIDE (FORM) */}
      <div className="login-right">
        <div className="login-box">

          <h2>Supervisor Login</h2>

          <input
            placeholder="Phone Number"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
          />

          <input
            placeholder="PIN"
            type="password"
            value={pin}
            onChange={(e) => setPin(e.target.value)}
          />

          <button onClick={handleLogin}>Login</button>

          <p className="switch-text">
            Don’t have an account?{" "}
            <span onClick={() => (window.location.href = "/register")}>
              Register
            </span>
          </p>

        </div>
      </div>

    </div>
  );
}

export default Login;