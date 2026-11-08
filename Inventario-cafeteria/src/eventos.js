// NO es un EventEmitter. Son funciones que el backend llama DESPUES de
// registrar un movimiento. Aqui nace la automatizacion de la entrega.
const pool = require('./database');

// Evalua si el insumo cruzo su minimo y crea/cierra la alerta automaticamente.
async function evaluateThreshold(productId) {
  const [[p]] = await pool.query(
    'SELECT id, name, category, unit, current_stock, min_stock FROM products WHERE id = ?',
    [productId]
  );
  if (!p) return { alert: false };

  const critical = p.current_stock <= p.min_stock;

  if (critical) {
    // Si esta critico y no hay alerta abierta, el sistema la CREA solo.
    const [[open]] = await pool.query(
      'SELECT COUNT(*) AS n FROM alerts WHERE product_id = ? AND resolved = 0',
      [productId]
    );
    if (open.n === 0) {
      await pool.query(
        'INSERT INTO alerts (product_id, stock_at_detection, min_stock) VALUES (?,?,?)',
        [productId, p.current_stock, p.min_stock]
      );
    }
  } else {
    // Si ya repusieron y subio del minimo, se cierra la alerta pendiente.
    await pool.query(
      'UPDATE alerts SET resolved = 1 WHERE product_id = ? AND resolved = 0',
      [productId]
    );
  }
  return { alert: critical, product: p };
}

async function listAlerts() {
  const [rows] = await pool.query(`
    SELECT a.id, a.product_id, p.name, p.category, p.unit,
           a.stock_at_detection, a.min_stock, a.created_at
    FROM alerts a JOIN products p ON p.id = a.product_id
    WHERE a.resolved = 0
    ORDER BY a.created_at DESC`);
  return rows;
}

async function resolveAlert(id) {
  await pool.query('UPDATE alerts SET resolved = 1 WHERE id = ?', [id]);
  return { ok: true };
}

module.exports = { evaluateThreshold, listAlerts, resolveAlert };