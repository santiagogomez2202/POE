const pool = require('./database');
const { evaluateThreshold } = require('./eventos');

// Solo estas columnas se pueden escribir (evita meter campos invalidos).
const PRODUCT_COLS = ['name','category','unit','cost_price','current_stock','min_stock','supplier_id'];
const MOVEMENT_COLS = ['product_id','type','quantity','reason'];

function pick(obj, cols) {
  const r = {};
  cols.forEach(k => {
    if (obj[k] !== undefined) r[k] = (obj[k] === '' ? null : obj[k]);
  });
  return r;
}

// ---- CRUD de insumos ----
const list = () => pool.query('SELECT * FROM products ORDER BY name').then(r => r[0]);
const get = (id) => pool.query('SELECT * FROM products WHERE id = ?', [id]).then(r => r[0][0] || null);
const create = (d) => pool.query('INSERT INTO products SET ?', [pick(d, PRODUCT_COLS)]).then(r => r[0].insertId);
const update = (id, d) => pool.query('UPDATE products SET ? WHERE id = ?', [pick(d, PRODUCT_COLS), id]);
const remove = (id) => pool.query('DELETE FROM products WHERE id = ?', [id]);

// ---- Proveedores (para el select del modal) ----
const listSuppliers = () => pool.query('SELECT id, name FROM suppliers ORDER BY name').then(r => r[0]);

// ---- Movimientos: resta/suma stock y DISPARA la alerta ----
async function registerMovement(d) {
  const m = pick(d, MOVEMENT_COLS);
  if (!m.product_id || !m.type || !m.quantity) throw new Error('Incomplete movement data');
  const quantity = Number(m.quantity);
  if (quantity <= 0) throw new Error('Quantity must be greater than 0');

  const delta = m.type === 'inflow' ? quantity : -quantity;
  await pool.query('UPDATE products SET current_stock = current_stock + ? WHERE id = ?', [delta, m.product_id]);
  await pool.query('INSERT INTO movements SET ?', [
    { product_id: m.product_id, type: m.type, quantity, reason: m.reason || null }
  ]);
  return evaluateThreshold(m.product_id); // <-- aqui se genera la alerta sola
}

// Historial agrupado por dia y tipo (para la grafica de Chart.js)
const recentMovements = (days = 7) => pool.query(`
  SELECT DATE(created_at) AS day, type, SUM(quantity) AS total
  FROM movements
  WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
  GROUP BY day, type
  ORDER BY day`, [days]).then(r => r[0]);

// KPIs del panel
async function summary() {
  const [[k]] = await pool.query(`
    SELECT
      (SELECT COUNT(*) FROM products) AS supplies,
      (SELECT COUNT(*) FROM alerts WHERE resolved = 0) AS alerts,
      (SELECT COALESCE(SUM(current_stock * cost_price),0) FROM products) AS value,
      (SELECT COUNT(*) FROM products WHERE current_stock <= min_stock) AS critical`);
  return k;
}

module.exports = { list, get, create, update, remove, listSuppliers, registerMovement, recentMovements, summary };