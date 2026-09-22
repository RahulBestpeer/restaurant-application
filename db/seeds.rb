puts "Seeding menu categories..."

food     = MenuCategory.find_or_create_by!(slug: "food")      { |c| c.name = "Food";      c.category_type = "food";     c.display_order = 1; c.active = true }
beverage = MenuCategory.find_or_create_by!(slug: "beverages") { |c| c.name = "Beverages"; c.category_type = "beverage"; c.display_order = 2; c.active = true }
paella   = MenuCategory.find_or_create_by!(slug: "paella")    { |c| c.name = "Paella";    c.category_type = "paella";   c.display_order = 3; c.active = true }
tapas    = MenuCategory.find_or_create_by!(slug: "tapas")     { |c| c.name = "Tapas";     c.category_type = "tapas";    c.display_order = 4; c.active = true }

starters    = MenuCategory.find_or_create_by!(slug: "starters")     { |c| c.name = "Starters";     c.category_type = "food";     c.display_order = 1; c.active = true; c.parent = food }
mains       = MenuCategory.find_or_create_by!(slug: "main-courses") { |c| c.name = "Main Courses"; c.category_type = "food";     c.display_order = 2; c.active = true; c.parent = food }
desserts    = MenuCategory.find_or_create_by!(slug: "desserts")     { |c| c.name = "Desserts";     c.category_type = "food";     c.display_order = 3; c.active = true; c.parent = food }
wines       = MenuCategory.find_or_create_by!(slug: "wines")        { |c| c.name = "Wines";        c.category_type = "beverage"; c.display_order = 1; c.active = true; c.parent = beverage }
beers       = MenuCategory.find_or_create_by!(slug: "beers")        { |c| c.name = "Beers";        c.category_type = "beverage"; c.display_order = 2; c.active = true; c.parent = beverage }
cocktails   = MenuCategory.find_or_create_by!(slug: "cocktails")    { |c| c.name = "Cocktails";    c.category_type = "beverage"; c.display_order = 3; c.active = true; c.parent = beverage }
soft_drinks = MenuCategory.find_or_create_by!(slug: "soft-drinks")  { |c| c.name = "Soft Drinks";  c.category_type = "beverage"; c.display_order = 4; c.active = true; c.parent = beverage }

puts "  Categories: #{MenuCategory.count}"

puts "Seeding menu items..."

items = [
  # Starters
  { category: starters, name: "Gazpacho Andaluz",      desc: "Traditional cold tomato soup with cucumber, pepper and olive oil. Served with croutons.", price: 8.50,  featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },
  { category: starters, name: "Jamón Ibérico Platter", desc: "Premium Iberian cured ham, aged 36 months, served with pan con tomate.",                   price: 22.00, featured: true,  dietary: { gluten_free: true } },
  { category: starters, name: "Croquetas de la Casa",  desc: "House-made croquettes filled with jamón ibérico and béchamel. Crispy golden exterior.",     price: 9.00,  featured: true,  dietary: {} },
  { category: starters, name: "Patatas Bravas",        desc: "Crispy fried potatoes with spicy brava sauce and aioli.",                                    price: 7.50,  featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },

  # Main Courses
  { category: mains, name: "Cocido Madrileño",   desc: "Classic Madrid-style chickpea stew with pork, chorizo, morcilla and seasonal vegetables.", price: 19.50, featured: true,  dietary: { gluten_free: true } },
  { category: mains, name: "Merluza a la Vasca", desc: "Basque-style hake in a green sauce with clams, asparagus and hard-boiled egg.",            price: 23.00, featured: false, dietary: { gluten_free: true } },
  { category: mains, name: "Cordero Asado",      desc: "Slow-roasted Castilian lamb, seasoned with garlic, rosemary and white wine.",              price: 27.00, featured: true,  dietary: { gluten_free: true } },

  # Desserts
  { category: desserts, name: "Crema Catalana",     desc: "Classic Catalan custard with a caramelised sugar crust. Served warm.",                 price: 7.00, featured: false, dietary: { vegetarian: true, gluten_free: true } },
  { category: desserts, name: "Churros con Chocolate", desc: "Freshly fried churros served with thick Spanish hot chocolate for dipping.",        price: 6.50, featured: true,  dietary: { vegetarian: true } },

  # Paella
  { category: paella, name: "Paella Valenciana",  desc: "The original. Free-range chicken, rabbit, green beans, butter beans, tomato and saffron. Serves 2.", price: 38.00, featured: true,  dietary: { gluten_free: true } },
  { category: paella, name: "Paella de Mariscos", desc: "Seafood paella with prawns, mussels, clams and squid in a rich seafood stock. Serves 2.",           price: 46.00, featured: true,  dietary: { gluten_free: true } },
  { category: paella, name: "Paella Mixta",       desc: "A combination of chicken, rabbit and fresh seafood with saffron rice. Serves 2.",                    price: 42.00, featured: false, dietary: { gluten_free: true } },
  { category: paella, name: "Paella Negra",       desc: "Black rice coloured with squid ink, baby squid, prawn and alioli. Serves 2.",                        price: 44.00, featured: false, dietary: { gluten_free: true } },
  { category: paella, name: "Paella Vegetariana", desc: "Seasonal vegetables, artichoke, red pepper, mushroom and saffron. Serves 2.",                        price: 32.00, featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },

  # Tapas
  { category: tapas, name: "Pan con Tomate",                desc: "Toasted bread rubbed with ripe tomato and drizzled with extra virgin olive oil.",          price: 4.50,  featured: false, dietary: { vegetarian: true, vegan: true } },
  { category: tapas, name: "Gambas al Ajillo",             desc: "Sizzling king prawns in garlic-infused olive oil with dried chilli and parsley.",           price: 13.50, featured: true,  dietary: { gluten_free: true } },
  { category: tapas, name: "Pimientos de Padrón",          desc: "Flash-fried Padrón peppers with sea salt. Some are hot, most are not!",                    price: 8.00,  featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },
  { category: tapas, name: "Albóndigas en Salsa",          desc: "Tender pork and beef meatballs in a slow-cooked tomato and herb sauce.",                    price: 10.50, featured: true,  dietary: {} },
  { category: tapas, name: "Queso Manchego con Membrillo", desc: "Aged Manchego cheese served with quince paste and honey.",                                  price: 9.50,  featured: false, dietary: { vegetarian: true, gluten_free: true } },

  # Wines
  { category: wines, name: "Rioja Reserva — Marqués de Cáceres", desc: "Full-bodied red with notes of cherry, vanilla and spice. 75cl bottle.",                      price: 34.00, featured: true,  dietary: { vegan: true, gluten_free: true } },
  { category: wines, name: "Albariño — Rías Baixas",             desc: "Crisp, aromatic white wine with citrus and stone fruit. Excellent with seafood. 75cl.",      price: 28.00, featured: false, dietary: { vegan: true, gluten_free: true } },
  { category: wines, name: "Cava Brut Nature — Gramona",         desc: "Elegant Spanish sparkling wine, dry with fine bubbles and toasted brioche notes. 75cl.",      price: 32.00, featured: false, dietary: { vegan: true, gluten_free: true } },
  { category: wines, name: "House Wine — Red / White / Rosé",    desc: "Our carefully selected house wine. Ask your server for today's selection.",                   price: 5.50,  featured: false, dietary: { vegan: true, gluten_free: true } },

  # Beers
  { category: beers, name: "Mahou Cinco Estrellas (330ml)", desc: "Madrid's iconic lager. Crisp, refreshing and perfectly balanced.", price: 3.50, featured: false, dietary: { vegan: true } },
  { category: beers, name: "Estrella Damm (330ml)",         desc: "Premium Barcelona lager brewed with Saaz hops. Light and aromatic.", price: 3.50, featured: false, dietary: { vegan: true } },

  # Cocktails
  { category: cocktails, name: "Sangría de la Casa", desc: "House red wine sangría with seasonal fruit, brandy and orange juice. 500ml jug.", price: 18.00, featured: true,  dietary: { vegan: true, gluten_free: true } },
  { category: cocktails, name: "Tinto de Verano",    desc: "Classic Spanish summer drink — red wine with lemon-flavoured soda over ice.",     price: 6.00,  featured: false, dietary: { vegan: true, gluten_free: true } },

  # Soft Drinks
  { category: soft_drinks, name: "Agua Mineral (500ml)", desc: "Still or sparkling mineral water.",      price: 2.50, featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },
  { category: soft_drinks, name: "Fresh Orange Juice",   desc: "Freshly squeezed Valencia oranges.",     price: 4.00, featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } }
]

items.each_with_index do |d, i|
  MenuItem.find_or_create_by!(name: d[:name], menu_category: d[:category]) do |item|
    item.description   = d[:desc]
    item.price         = d[:price]
    item.featured      = d.fetch(:featured, false)
    item.available     = true
    item.dietary_flags = d.fetch(:dietary, {})
    item.display_order = i
  end
end

puts "  Menu items: #{MenuItem.count}"
