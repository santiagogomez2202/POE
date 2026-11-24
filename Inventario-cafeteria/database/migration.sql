
INSERT INTO suppliers (name, contact, phone) VALUES
('Café de Origen Jalisco', 'Juan Pérez', '33-1247-8932'),
('Dulce Tentación Bakery', 'María González', '33-2891-4567'),
('Lácteos del Valle de Atemajac', 'Carlos Ramírez', '33-3456-7821'),
('Frutas Tropicales de Sayula', 'Ana Martínez', '33-4782-9103'),
('EcoPack Guadalajara', 'Roberto Sánchez', '33-5123-6789'),
('Endulzantes y Saborizantes MX', 'Laura Torres', '33-6891-2345'),
('Té & Infusiones Premium', 'Diego Morales', '33-7234-5678');

INSERT INTO products (name, category, unit, cost_price, current_stock, min_stock, supplier_id) VALUES

-- Supplier 1: Café de Origen Jalisco (Especialista en CAFÉ)
('Café Americano', 'Coffee', 'cup', 12, 100, 20, 1),
('Espresso Doble', 'Coffee', 'cup', 18, 80, 15, 1),
('Cappuccino', 'Coffee', 'cup', 24, 70, 15, 1),
('Caffè Latte', 'Coffee', 'cup', 22, 75, 15, 1),
('Macchiato', 'Coffee', 'cup', 20, 60, 10, 1),
('Mocha', 'Coffee', 'cup', 28, 50, 10, 1),

-- Supplier 2: Dulce Tentación Bakery (Especialista en POSTRES Y PANADERÍA)
('Croissant de Mantequilla', 'Bakery', 'piece', 18, 40, 10, 2),
('Muffin de Arándanos', 'Bakery', 'piece', 22, 35, 10, 2),
('Rol de Canela', 'Bakery', 'piece', 25, 30, 8, 2),
('Galleta de Chocolate', 'Bakery', 'piece', 15, 60, 15, 2),
('Cheesecake', 'Bakery', 'piece', 45, 20, 5, 2),
('Brownie', 'Bakery', 'piece', 28, 35, 8, 2),

-- Supplier 3: Lácteos del Valle de Atemajac (Especialista en LÁCTEOS)
('Leche Entera', 'Dairy', 'liter', 22, 50, 10, 3),
('Leche Deslactosada', 'Dairy', 'liter', 24, 45, 10, 3),
('Leche de Avena', 'Dairy', 'liter', 45, 30, 8, 3),
('Leche de Almendra', 'Dairy', 'liter', 50, 25, 8, 3),
('Crema para Batir', 'Dairy', 'liter', 65, 20, 5, 3),
('Queso Crema', 'Dairy', 'kg', 95, 15, 5, 3),

-- Supplier 4: Frutas Tropicales de Sayula (Especialista en FRUTAS Y BEBIDAS FRÍAS)
('Fresa', 'Fruits', 'kg', 55, 20, 5, 4),
('Mango', 'Fruits', 'kg', 35, 15, 4, 4),
('Plátano', 'Fruits', 'kg', 18, 25, 5, 4),
('Aguacate', 'Fruits', 'kg', 45, 18, 5, 4),
('Jugo de Naranja', 'Cold Drinks', 'glass', 30, 25, 5, 4),
('Smoothie Verde', 'Cold Drinks', 'glass', 40, 20, 5, 4),

-- Supplier 5: EcoPack Guadalajara (Especialista en DESECHABLES)
('Vaso de Papel 8oz', 'Disposables', 'piece', 1.5, 1000, 200, 5),
('Vaso de Papel 12oz', 'Disposables', 'piece', 2.0, 800, 200, 5),
('Vaso de Papel 16oz', 'Disposables', 'piece', 2.5, 600, 150, 5),
('Popote de Papel', 'Disposables', 'piece', 0.5, 2000, 500, 5),
('Tapa Plástica 12oz', 'Disposables', 'piece', 1.0, 800, 200, 5),
('Caja para Llevar', 'Disposables', 'piece', 3.5, 300, 50, 5),

-- Supplier 6: Endulzantes y Saborizantes MX (Especialista en JARABES Y TOPPINGS)
('Jarabe de Vainilla', 'Toppings', 'liter', 85, 15, 3, 6),
('Jarabe de Caramelo', 'Toppings', 'liter', 85, 15, 3, 6),
('Jarabe de Avellana', 'Toppings', 'liter', 90, 12, 3, 6),
('Salsa de Chocolate', 'Toppings', 'liter', 75, 18, 5, 6),
('Miel de Abeja', 'Toppings', 'jar', 110, 10, 3, 6),
('Mermelada de Fresa', 'Toppings', 'jar', 60, 20, 5, 6),

-- Supplier 7: Té & Infusiones Premium (Especialista en TÉ E INFUSIONES)
('Té Earl Grey', 'Tea', 'cup', 15, 50, 10, 7),
('Té Verde', 'Tea', 'cup', 14, 55, 10, 7),
('Té de Manzanilla', 'Tea', 'cup', 12, 50, 10, 7),
('Matcha Latte', 'Tea', 'cup', 28, 40, 10, 7),
('Chai Latte', 'Tea', 'cup', 26, 35, 8, 7),
('Té Helado de Limón', 'Tea', 'cup', 18, 45, 10, 7);