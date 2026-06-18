const express = require("express");
const app = express();

const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({ message: "Docker Optimization Project Running" });
});

app.get("/health", (req, res) => {
  res.status(200).json({ status: "UP" });
});

// Graceful shutdown
const server = app.listen(PORT, () => {
  console.log(`Server running on ${PORT}`);
});

process.on("SIGTERM", () => {
  console.log("SIGTERM received");
  server.close(() => {
    console.log("Process terminated");
  });
});

