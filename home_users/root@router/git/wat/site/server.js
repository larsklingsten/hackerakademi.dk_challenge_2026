// [ε] root@router:~/git/wat# cat site/server.js
const express = require("express");

const app = express();
app.use(express.static("public"));

app.use(express.raw({ type: "application/octet-stream", limit: "10mb" }));

app.post("/runwasm", (req, res) => {
  try {
    const binaryBuffer = req.body;
    let module = new WebAssembly.Module(binaryBuffer);
    let instance = new WebAssembly.Instance(module);
    res.json({ status: "ok" });
  } catch (err) {
    res.json({ status: "err", err: err.toString() });
  }
});

app.listen(3000, () => {
  console.log("Server running at http://localhost:3000");
});