const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

// CORS middleware for frontend
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

const JWT_SECRET = process.env.JWT_SECRET || 'your-very-secret';

// simple JWT validation middleware
function authRequired(req, res, next) {
  const auth = req.headers.authorization;
  if (!auth) return res.status(401).json({ error: 'Missing auth' });
  const token = auth.split(' ')[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    req.user = payload;
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

// Public route: create user (no auth)
app.use('/users', createProxyMiddleware({ 
  target: 'http://user-service:3004', 
  changeOrigin: true,
  onError: (err, req, res) => {
    console.error('Proxy error:', err);
    res.status(500).json({ error: 'Service unavailable' });
  }
}));

// Orders (public for demo purposes)
app.use('/orders', createProxyMiddleware({ target: 'http://order-service:3003', changeOrigin: true }));

// Inventory routes (public for demo purposes)
app.use('/inventory', createProxyMiddleware({ target: 'http://inventory-service:3001', changeOrigin: true }));

// health
app.get('/health', (req, res)=> res.json({ status: 'ok', gateway: true }));

// (moved CORS before proxies)

const PORT = process.env.PORT || 3000;
app.listen(PORT, ()=> console.log(`API Gateway listening on ${PORT}`));