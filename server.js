const express = require('express');
const cors = require('cors');
const path = require('path');
const projectDir = path.join(__dirname, 'Inventario-cafeteria');
const prod = require(path.join(projectDir, 'src', 'productos'));
const { listAlerts, resolveAlert } = require(path.join(projectDir, 'src', 'eventos'));

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(projectDir, 'public'))); // sirve index.html, styles.css, app.js

// ---- Insumos ----
app.get('/api/products', async (q, r, n) => { try { r.json(await prod.list()); } catch (e) { n(e); } });
app.get('/api/products/:id', async (q, r, n) => { try { const p = await prod.get(q.params.id); p ? r.json(p) : r.status(404).json({ error: 'Not found' }); } catch (e) { n(e); } });
app.post('/api/products', async (q, r, n) => { try { r.status(201).json({ id: await prod.create(q.body) }); } catch (e) { n(e); } });
app.put('/api/products/:id', async (q, r, n) => { try { await prod.update(q.params.id, q.body); r.json({ ok: true }); } catch (e) { n(e); } });
app.delete('/api/products/:id', async (q, r, n) => { try { await prod.remove(q.params.id); r.json({ ok: true }); } catch (e) { n(e); } });

// ---- Proveedores ----
app.get('/api/suppliers', async (q, r, n) => { try { r.json(await prod.listSuppliers()); } catch (e) { n(e); } });

// ---- Movimientos (aqui vive la automatizacion) ----
app.post('/api/movements', async (q, r, n) => { try { r.json(await prod.registerMovement(q.body)); } catch (e) { n(e); } });
app.get('/api/movements', async (q, r, n) => { try { r.json(await prod.recentMovements()); } catch (e) { n(e); } });

// ---- Alertas ----
app.get('/api/alerts', async (q, r, n) => { try { r.json(await listAlerts()); } catch (e) { n(e); } });
app.patch('/api/alerts/:id/resolve', async (q, r, n) => { try { r.json(await resolveAlert(q.params.id)); } catch (e) { n(e); } });

// ---- KPIs ----
app.get('/api/summary', async (q, r, n) => { try { r.json(await prod.summary()); } catch (e) { n(e); } });

// Manejador de errores (siempre al final)
app.use((err, q, r, n) => {
  console.error('💥', err.message);
  r.status(400).json({ error: err.message });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`☕ Cafeteria running at http://localhost:${PORT}`));