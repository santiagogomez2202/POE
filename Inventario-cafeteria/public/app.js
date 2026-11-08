// ===== Helpers =====
const $ = (s) => document.querySelector(s);
const api = (url, opts) => fetch(url, opts).then(r => r.json());
const CAT = {
  beverage:{e:''}, dairy:{e:''}, sweetener:{e:''},
  packaging:{e:''}, pastry:{e:''}
};
const money = (n) => '$' + Number(n || 0).toLocaleString('en-US', {minimumFractionDigits:0, maximumFractionDigits:0});

function toast(msg, tipo='info'){
  const t = document.createElement('div');
  t.className = 'toast ' + tipo; t.textContent = msg;
  $('#toasts').appendChild(t);
  setTimeout(() => t.classList.add('show'), 10);
  setTimeout(() => { t.classList.remove('show'); setTimeout(() => t.remove(), 300); }, 4200);
}

// ===== Pestañas =====
document.querySelectorAll('nav button').forEach(b => b.onclick = () => {
  document.querySelectorAll('nav button').forEach(x => x.classList.remove('active'));
  document.querySelectorAll('.tab').forEach(x => x.classList.remove('active'));
  b.classList.add('active');
  $('#tab-' + b.dataset.tab).classList.add('active');
});

// ===== Carga general =====
let productsCache = [];
async function loadAll(){
  const [sum, products, alerts, movs, provs] = await Promise.all([
    api('/api/summary'), api('/api/products'), api('/api/alerts'),
    api('/api/movements'), api('/api/suppliers')
  ]);
  productsCache = products;

  // KPIs
  $('#k-supplies').textContent = sum.supplies;
  $('#k-alerts').textContent = sum.alerts;
  $('#k-critical').textContent = sum.critical;
  $('#k-value').textContent = money(sum.value);

  renderAlerts(alerts);
  renderTable(products);
  renderChart(movs);
  fillSelects(provs, products);
}

function renderAlerts(list){
  const c = $('#alert-list');
  if(!list.length){ c.innerHTML = '<p class="muted"> No alerts. Inventory at healthy levels.</p>'; return; }
  c.innerHTML = list.map(a => {
    const cat = CAT[a.category]?.e || '📦';
    return `<div class="alert">
      <div class="txt"><b>${cat} ${a.name}</b>
        <small>stock ${a.stock_at_detection} / min ${a.min_stock} · ${a.unit}</small></div>
      <button class="btn sm" onclick="resolve(${a.id})">✔ Resolved</button>
    </div>`;
  }).join('');
}

function renderTable(rows){
  const q = ($('#search').value || '').toLowerCase();
  const fc = $('#filter-cat').value;
  const fil = rows.filter(p =>
    (!fc || p.category === fc) &&
    (!q || p.name.toLowerCase().includes(q) || (p.category||'').includes(q))
  );
  const tb = $('#tbody-supplies');
  if(!fil.length){ tb.innerHTML = '<tr><td colspan="7" class="muted">No results</td></tr>'; return; }
  tb.innerHTML = fil.map(p => {
    const crit = p.current_stock <= p.min_stock;
    const cat = CAT[p.category] || {e:''};
    return `<tr class="${crit?'critical':''}">
      <td>${cat.e} <b>${p.name}</b></td>
      <td><span class="chip ${p.category}">${p.category}</span></td>
      <td>${p.unit || '-'}</td>
      <td>${p.current_stock}</td>
      <td>${p.min_stock}</td>
      <td>${crit ? '<span class="badge critical"> Restock</span>' : '<span class="badge ok">🟢 OK</span>'}</td>
      <td>
        <button class="btn sm" onclick="edit(${p.id})"></button>
        <button class="btn sm danger" onclick="remove(${p.id},'${p.name.replace(/'/g,"\\'")}')">🗑</button>
      </td>
    </tr>`;
  }).join('');
}

let chart;
function renderChart(movs){
  const days = [...new Set(movs.map(m => String(m.day).slice(0,10)))].sort();
  const inf = days.map(d => movs.find(m => String(m.day).slice(0,10)===d && m.type==='inflow')?.total || 0);
  const outf = days.map(d => movs.find(m => String(m.day).slice(0,10)===d && m.type==='outflow')?.total || 0);
  if(chart) chart.destroy();
  chart = new Chart($('#chart-canvas'), {
    type:'bar',
    data:{ labels:days, datasets:[
      {label:'Inflows', data:inf, backgroundColor:'#2e7d32'},
      {label:'Outflows', data:outf, backgroundColor:'#c62828'}
    ]},
    options:{ responsive:true, plugins:{legend:{position:'bottom'}}, scales:{y:{beginAtZero:true, ticks:{precision:0}}} }
  });
}

function fillSelects(provs, products){
  $('#p-supplier').innerHTML = '<option value="">(no supplier)</option>' +
    provs.map(p => `<option value="${p.id}">${p.name}</option>`).join('');
  $('#mov-product').innerHTML = products.map(p =>
    `<option value="${p.id}">${(CAT[p.category]?.e||'📦')} ${p.name} (stock ${p.current_stock})</option>`
  ).join('');
}

// ===== CRUD =====
function openModal(){
  $('#modal-title').textContent = 'New supply';
  ['p-id','p-name','p-unit','p-cost','p-stock','p-min'].forEach(id => $('#'+id).value = '');
  $('#p-cat').value = 'beverage'; $('#p-supplier').value = '';
  $('#modal').classList.add('open');
}
async function edit(id){
  const p = await api('/api/products/' + id);
  $('#modal-title').textContent = 'Edit supply';
  $('#p-id').value = p.id; $('#p-name').value = p.name; $('#p-cat').value = p.category;
  $('#p-unit').value = p.unit || ''; $('#p-cost').value = p.cost_price;
  $('#p-supplier').value = p.supplier_id || ''; $('#p-stock').value = p.current_stock; $('#p-min').value = p.min_stock;
  $('#modal').classList.add('open');
}
function closeModal(){ $('#modal').classList.remove('open'); }

async function saveProduct(){
  const id = $('#p-id').value;
  const body = {
    name: $('#p-name').value.trim(),
    category: $('#p-cat').value,
    unit: $('#p-unit').value.trim(),
    cost_price: Number($('#p-cost').value) || 0,
    supplier_id: $('#p-supplier').value || null,
    current_stock: Number($('#p-stock').value) || 0,
    min_stock: Number($('#p-min').value) || 0,
  };
  if(!body.name){ toast('Name is required','critical'); return; }
  const url = id ? '/api/products/' + id : '/api/products';
  const method = id ? 'PUT' : 'POST';
  await api(url, { method, headers:{'Content-Type':'application/json'}, body: JSON.stringify(body) });
  toast(id ? 'Supply updated' : 'Supply created', 'success');
  closeModal(); loadAll();
}

async function remove(id, name){
  if(!confirm(`Delete "${name}"?`)) return;
  await api('/api/products/' + id, { method:'DELETE' });
  toast('Supply deleted', 'info'); loadAll();
}

async function resolve(id){
  await api('/api/alerts/' + id + '/resolve', { method:'PATCH' });
  toast('Alert marked as resolved', 'success'); loadAll();
}

// ===== Movimiento (dispara la alerta automatica) =====
async function registerMovement(){
  const type = document.querySelector('input[name=type]:checked').value;
  const body = {
    product_id: Number($('#mov-product').value),
    type,
    quantity: Number($('#mov-qty').value),
    reason: $('#mov-reason').value || null,
  };
  if(!body.product_id || !body.quantity){ toast('Select supply and quantity','critical'); return; }
  const r = await api('/api/movements', { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(body) });
  if(r.alert){
    toast(` Automatic alert: "${r.product.name}" reached critical stock (${r.product.current_stock}/${r.product.min_stock}).`,'critical');
  } else {
    toast(' Movement registered','success');
  }
  $('#mov-qty').value = 1; $('#mov-reason').value = '';
  loadAll();
}

// ===== Filtros en vivo =====
$('#search').oninput = () => renderTable(productsCache);
$('#filter-cat').onchange = () => renderTable(productsCache);

// Arrancar
loadAll();