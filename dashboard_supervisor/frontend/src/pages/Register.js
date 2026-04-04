import { useState } from "react";
import "../styles/login.css"; // reuse same style

function Register() {
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [pin, setPin] = useState("");
  const [role, setRole] = useState("SUPERVISOR");

  async function handleRegister() {
    try {
      const res = await fetch("http://localhost:8080/api/auth/register", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          name,
          phone,
          pin,
          role,
        }),
      });

      const data = await res.json();

      if (data.success) {
        alert("Registered successfully!");
        window.location.href = "/";
      } else {
        alert(data.message);
      }
    } catch (err) {
      alert("Registration failed");
    }
  }

  return (
    <div className="login-container">
      
      {/* LEFT SIDE */}
      <div className="login-left">
        <h1>NutriLink</h1>
        <p>Create Supervisor / Worker Account</p>
      </div>

      {/* RIGHT SIDE */}
      <div className="login-right">
        <div className="login-box">

          <h2>Register</h2>

          <input
            placeholder="Full Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />

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

          {/* ROLE SELECT */}
          <select
            value={role}
            onChange={(e) => setRole(e.target.value)}
            className="dropdown"
          >
            <option value="SUPERVISOR">Supervisor</option>
            <option value="WORKER">Worker</option>
          </select>

          <button onClick={handleRegister}>Register</button>

          <p className="switch-text">
            Already have an account?{" "}
            <span onClick={() => (window.location.href = "/")}>
              Login
            </span>
          </p>

        </div>
      </div>

    </div>
  );
}

export default Register;