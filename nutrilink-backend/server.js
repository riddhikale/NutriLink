const express = require ('express')
const dotenv = require('dotenv');
const cors = require('cors')

dotenv.config();

const authRouters = require("./routes/authRoutes");
const screeningRoutes = require("./routes/screeningRoutes");
const beneficiaryRoutes = require("./routes/beneficiaryRoutes")
const dashboardRoutes = require("./routes/dashboardRoutes");

const app = express();
const port = process.env.PORT || 8080;

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

app.use(cors())
app.use(express.json())

app.get('/', (req,res) => {
    res.send('Hello from Backend!');
})

app.use("/api/auth", authRouters);
app.use("/api",screeningRoutes);
app.use("/api",beneficiaryRoutes);
app.use("/api", dashboardRoutes);

app.listen(port, () => {
    console.log('Server running...!');
})