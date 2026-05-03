import express from "express";
import { createServer as createViteServer } from "vite";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function startServer() {
  const app = express();
  const PORT = 3000;

  app.use(express.json());

  // Mock database
  let projects = [
    { id: "1", name: "Cloud Migrator", status: "Active", description: "Automated AWS migration scripts." },
    { id: "2", name: "Security Audit", status: "Pending", description: "Compliance scanning for Kubernetes clusters." }
  ];

  // API Routes
  app.get("/api/projects", (req, res) => {
    res.json(projects);
  });

  // Dynamic Route Example
  app.get("/api/projects/:id", (req, res) => {
    const project = projects.find(p => p.id === req.params.id);
    if (project) {
      res.json(project);
    } else {
      res.status(404).json({ error: "Project not found" });
    }
  });

  app.post("/api/projects", (req, res) => {
    const newProject = {
      id: Math.random().toString(36).substr(2, 9),
      ...req.body,
    };
    projects.push(newProject);
    res.status(201).json(newProject);
  });

  // Health check endpoint (for the monitoring requirement)
  app.get("/api/health", (req, res) => {
    res.json({ 
      status: "healthy", 
      timestamp: new Date().toISOString(),
      uptime: process.uptime()
    });
  });

  // Vite middleware for development
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), "dist");
    app.use(express.static(distPath));
    app.get("*", (req, res) => {
      res.sendFile(path.join(distPath, "index.html"));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
}

startServer();
