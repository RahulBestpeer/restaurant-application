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
  # Starters — prices in INR
  { category: starters, name: "Gazpacho Andaluz",      desc: "Traditional cold tomato soup with cucumber, pepper and olive oil. Served with croutons.", price: 650,   featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },
  { category: starters, name: "Jamón Ibérico Platter", desc: "Premium Iberian cured ham, aged 36 months, served with pan con tomate.",                   price: 1850,  featured: true,  dietary: { gluten_free: true } },
  { category: starters, name: "Croquetas de la Casa",  desc: "House-made croquettes filled with jamón ibérico and béchamel. Crispy golden exterior.",     price: 750,   featured: true,  dietary: {} },
  { category: starters, name: "Patatas Bravas",        desc: "Crispy fried potatoes with spicy brava sauce and aioli.",                                    price: 550,   featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },

  # Main Courses
  { category: mains, name: "Cocido Madrileño",   desc: "Classic Madrid-style chickpea stew with pork, chorizo, morcilla and seasonal vegetables.", price: 1650,  featured: true,  dietary: { gluten_free: true } },
  { category: mains, name: "Merluza a la Vasca", desc: "Basque-style hake in a green sauce with clams, asparagus and hard-boiled egg.",            price: 1950,  featured: false, dietary: { gluten_free: true } },
  { category: mains, name: "Cordero Asado",      desc: "Slow-roasted Castilian lamb, seasoned with garlic, rosemary and white wine.",              price: 2250,  featured: true,  dietary: { gluten_free: true } },

  # Desserts
  { category: desserts, name: "Crema Catalana",        desc: "Classic Catalan custard with a caramelised sugar crust. Served warm.",          price: 550,  featured: false, dietary: { vegetarian: true, gluten_free: true } },
  { category: desserts, name: "Churros con Chocolate", desc: "Freshly fried churros served with thick Spanish hot chocolate for dipping.",     price: 499,  featured: true,  dietary: { vegetarian: true } },

  # Paella — serves 2
  { category: paella, name: "Paella Valenciana",  desc: "The original. Free-range chicken, rabbit, green beans, butter beans, tomato and saffron. Serves 2.", price: 3200,  featured: true,  dietary: { gluten_free: true } },
  { category: paella, name: "Paella de Mariscos", desc: "Seafood paella with prawns, mussels, clams and squid in a rich seafood stock. Serves 2.",           price: 3900,  featured: true,  dietary: { gluten_free: true } },
  { category: paella, name: "Paella Mixta",       desc: "A combination of chicken, rabbit and fresh seafood with saffron rice. Serves 2.",                    price: 3550,  featured: false, dietary: { gluten_free: true } },
  { category: paella, name: "Paella Negra",       desc: "Black rice coloured with squid ink, baby squid, prawn and alioli. Serves 2.",                        price: 3750,  featured: false, dietary: { gluten_free: true } },
  { category: paella, name: "Paella Vegetariana", desc: "Seasonal vegetables, artichoke, red pepper, mushroom and saffron. Serves 2.",                        price: 2700,  featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },

  # Tapas
  { category: tapas, name: "Pan con Tomate",                desc: "Toasted bread rubbed with ripe tomato and drizzled with extra virgin olive oil.",          price: 350,   featured: false, dietary: { vegetarian: true, vegan: true } },
  { category: tapas, name: "Gambas al Ajillo",             desc: "Sizzling king prawns in garlic-infused olive oil with dried chilli and parsley.",           price: 1100,  featured: true,  dietary: { gluten_free: true } },
  { category: tapas, name: "Pimientos de Padrón",          desc: "Flash-fried Padrón peppers with sea salt. Some are hot, most are not!",                    price: 599,   featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },
  { category: tapas, name: "Albóndigas en Salsa",          desc: "Tender pork and beef meatballs in a slow-cooked tomato and herb sauce.",                    price: 850,   featured: true,  dietary: {} },
  { category: tapas, name: "Queso Manchego con Membrillo", desc: "Aged Manchego cheese served with quince paste and honey.",                                  price: 799,   featured: false, dietary: { vegetarian: true, gluten_free: true } },

  # Wines — 75cl bottle
  { category: wines, name: "Rioja Reserva — Marqués de Cáceres", desc: "Full-bodied red with notes of cherry, vanilla and spice. 75cl bottle.",                 price: 2850,  featured: true,  dietary: { vegan: true, gluten_free: true } },
  { category: wines, name: "Albariño — Rías Baixas",             desc: "Crisp, aromatic white wine with citrus and stone fruit. Excellent with seafood. 75cl.", price: 2350,  featured: false, dietary: { vegan: true, gluten_free: true } },
  { category: wines, name: "Cava Brut Nature — Gramona",         desc: "Elegant Spanish sparkling wine, dry with fine bubbles and toasted brioche notes. 75cl.", price: 2650,  featured: false, dietary: { vegan: true, gluten_free: true } },
  { category: wines, name: "House Wine — Red / White / Rosé",    desc: "Our carefully selected house wine. Ask your server for today's selection. Per glass.",   price: 450,   featured: false, dietary: { vegan: true, gluten_free: true } },

  # Beers
  { category: beers, name: "Mahou Cinco Estrellas (330ml)", desc: "Madrid's iconic lager. Crisp, refreshing and perfectly balanced.",        price: 280, featured: false, dietary: { vegan: true } },
  { category: beers, name: "Estrella Damm (330ml)",         desc: "Premium Barcelona lager brewed with Saaz hops. Light and aromatic.",       price: 280, featured: false, dietary: { vegan: true } },

  # Cocktails
  { category: cocktails, name: "Sangría de la Casa", desc: "House red wine sangría with seasonal fruit, brandy and orange juice. 500ml jug.", price: 1450, featured: true,  dietary: { vegan: true, gluten_free: true } },
  { category: cocktails, name: "Tinto de Verano",    desc: "Classic Spanish summer drink — red wine with lemon-flavoured soda over ice.",     price: 499,  featured: false, dietary: { vegan: true, gluten_free: true } },

  # Soft Drinks
  { category: soft_drinks, name: "Agua Mineral (500ml)", desc: "Still or sparkling mineral water.",   price: 120, featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } },
  { category: soft_drinks, name: "Fresh Orange Juice",   desc: "Freshly squeezed Valencia oranges.",  price: 299, featured: false, dietary: { vegetarian: true, vegan: true, gluten_free: true } }
]

items.each_with_index do |d, i|
  # Use find_or_initialize_by so re-running seeds updates prices on existing records
  item = MenuItem.find_or_initialize_by(name: d[:name], menu_category: d[:category])
  item.assign_attributes(
    description:   d[:desc],
    price:         d[:price],
    featured:      d.fetch(:featured, false),
    available:     true,
    dietary_flags: d.fetch(:dietary, {}),
    display_order: i
  )
  item.save!
end

puts "  Menu items: #{MenuItem.count}"

# ── Tables ──────────────────────────────────────────────────────────────────
puts "\nSeeding tables..."

[
  {
    number: "T1",
    capacity: 2,
    min_capacity: 1,
    location: "indoor",
    price: 2500.00,
    notes: "Window table"
  },
  {
    number: "T2",
    capacity: 2,
    min_capacity: 1,
    location: "indoor",
    price: 2500.00,
    notes: "Window table"
  },
  {
    number: "T3",
    capacity: 4,
    min_capacity: 2,
    location: "indoor",
    price: 3000.00,
    notes: "Premium indoor table"
  },
  {
    number: "T4",
    capacity: 4,
    min_capacity: 2,
    location: "indoor",
    price: 3000.00,
    notes: "Premium indoor table"
  },
  {
    number: "T5",
    capacity: 4,
    min_capacity: 2,
    location: "outdoor",
    price: 2800.00,
    notes: "Garden terrace table"
  },
  {
    number: "T6",
    capacity: 6,
    min_capacity: 4,
    location: "outdoor",
    price: 3500.00,
    notes: "Outdoor terrace table"
  },
  {
    number: "T7",
    capacity: 6,
    min_capacity: 4,
    location: "outdoor",
    price: 3500.00,
    notes: "Outdoor terrace table"
  },
  {
    number: "T8",
    capacity: 8,
    min_capacity: 6,
    location: "indoor",
    price: 4500.00,
    notes: "Large indoor table"
  },
  {
    number: "T9",
    capacity: 10,
    min_capacity: 6,
    location: "indoor",
    price: 5500.00,
    notes: "Large group table"
  },
  {
    number: "P1",
    capacity: 20,
    min_capacity: 10,
    location: "private",
    price: 12000.00,
    notes: "Private dining room"
  },
  {
    number: "B1",
    capacity: 4,
    min_capacity: 1,
    location: "bar",
    price: 1800.00,
    notes: "Bar seating"
  },
  {
    number: "B2",
    capacity: 4,
    min_capacity: 1,
    location: "bar",
    price: 1800.00,
    notes: "Bar seating"
  }
].each do |attrs|
  table = Table.find_or_initialize_by(number: attrs[:number])
  table.assign_attributes(attrs)
  table.save!
end

puts "  Tables: #{Table.count}"

# ── Events ───────────────────────────────────────────────────────────────────
puts "\nSeeding events..."

[
  {
    name:             "Flamenco Night",
    description:      "An authentic Spanish flamenco show accompanied by a curated tapas tasting menu and premium wine pairing.",
    event_date:       Date.current + 14,
    start_time:       "20:00",
    end_time:         "23:00",
    max_capacity:     40,
    price_per_person: 5500.00,
    status:           "upcoming",
    event_type:       "flamenco_show",
    booking_deadline: Date.current + 12
  },
  {
    name:             "Paella Masterclass",
    description:      "Learn to cook authentic Valencian paella with our head chef. Includes all ingredients, apron, and a family-style lunch.",
    event_date:       Date.current + 21,
    start_time:       "11:00",
    end_time:         "14:00",
    max_capacity:     16,
    price_per_person: 7000.00,
    status:           "upcoming",
    event_type:       "paella_class",
    booking_deadline: Date.current + 18
  },
  {
    name:             "Spanish Wine Tasting",
    description:      "Explore a curated selection of wines from Rioja, Ribera del Duero, and Galicia with expert sommelier commentary and tapas pairings.",
    event_date:       Date.current + 7,
    start_time:       "19:00",
    end_time:         "21:30",
    max_capacity:     24,
    price_per_person: 3800.00,
    status:           "upcoming",
    event_type:       "wine_tasting",
    booking_deadline: Date.current + 5
  },
  {
    name:             "Private Dining Experience",
    description:      "Exclusive use of our private dining room for celebrations, business dinners, or intimate gatherings. Custom menu available.",
    event_date:       Date.current + 30,
    start_time:       "19:30",
    end_time:         "23:00",
    max_capacity:     20,
    price_per_person: 8500.00,
    status:           "upcoming",
    event_type:       "private_dining",
    booking_deadline: Date.current + 27
  }
].each do |attrs|
  Event.find_or_initialize_by(name: attrs[:name]).tap do |e|
    e.assign_attributes(attrs)
    e.save!
  end
end

# Remove duplicate events created by prior seed runs (old relative dates)
Event.select(:name).group(:name).having("COUNT(*) > 1").pluck(:name).each do |name|
  Event.where(name: name).order(id: :desc).offset(1).destroy_all
end

puts "  Events: #{Event.count}"

# ── Gallery Items ────────────────────────────────────────────────────────────
puts "\nSeeding gallery items..."

[
  # Interior
  { title: "Main Dining Room",        category: "interior",   media_type: "photo", alt_text: "Elegant main dining room with warm lighting and Spanish décor",          position: 1, featured: true },
  { title: "Bar Area",                category: "interior",   media_type: "photo", alt_text: "Handcrafted wooden bar stocked with premium Spanish wines and spirits",  position: 2, featured: false },
  { title: "Private Dining Room",     category: "interior",   media_type: "photo", alt_text: "Intimate private dining room for exclusive events",                      position: 3, featured: false },
  { title: "Outdoor Terrace",         category: "interior",   media_type: "photo", alt_text: "Sunlit outdoor terrace with Mediterranean garden views",                 position: 4, featured: true },

  # Atmosphere
  { title: "Saturday Evening",        category: "atmosphere", media_type: "photo", alt_text: "Guests enjoying a vibrant Saturday evening at the restaurant",           position: 1, featured: true },
  { title: "Intimate Candlelit Table",category: "atmosphere", media_type: "photo", alt_text: "A romantic candlelit table set for two with fresh flowers",              position: 2, featured: false },

  # Food
  { title: "Patatas Bravas",          category: "food",       media_type: "photo", alt_text: "Crispy patatas bravas with spicy tomato and aioli sauces",               position: 1, featured: true },
  { title: "Jamón Ibérico Platter",   category: "food",       media_type: "photo", alt_text: "Hand-carved jamón ibérico de bellota served with pan con tomate",        position: 2, featured: true },
  { title: "Churros con Chocolate",   category: "food",       media_type: "photo", alt_text: "Fresh churros dusted with cinnamon sugar alongside thick hot chocolate", position: 3, featured: false },

  # Paella
  { title: "Paella Valenciana",       category: "paella",     media_type: "photo", alt_text: "Traditional Valencian paella cooked over open flame in a 60cm pan",      position: 1, featured: true },
  { title: "Paella Negra",            category: "paella",     media_type: "photo", alt_text: "Dramatic black squid ink paella topped with fresh alioli",               position: 2, featured: true },
  { title: "Seafood Paella",          category: "paella",     media_type: "photo", alt_text: "Generous seafood paella loaded with prawns, mussels and clams",          position: 3, featured: false },
  {
    title:       "How Our Paella is Made",
    category:    "paella",
    media_type:  "video",
    video_url:   "https://www.youtube.com/embed/dQw4w9WgXcQ",
    alt_text:    "Behind the scenes — our chef prepares authentic Valencian paella",
    description: "Watch our head chef walk through the entire paella-making process, from sourcing the bomba rice to achieving the perfect socarrat.",
    position:    4,
    featured:    true
  },

  # Tapas
  { title: "Croquetas de Jamón",      category: "tapas",      media_type: "photo", alt_text: "Golden crispy ham croquettes with a creamy béchamel centre",            position: 1, featured: true },
  { title: "Gambas al Ajillo",        category: "tapas",      media_type: "photo", alt_text: "Sizzling king prawns in garlic and chilli olive oil",                   position: 2, featured: true },
  { title: "Pimientos de Padrón",     category: "tapas",      media_type: "photo", alt_text: "Blistered Padrón peppers with Maldon sea salt",                         position: 3, featured: false },

  # Events
  { title: "Flamenco Night Highlight",category: "events",     media_type: "photo", alt_text: "Flamenco dancer performing passionately in the restaurant",              position: 1, featured: true },
  { title: "Wine Tasting Evening",    category: "events",     media_type: "photo", alt_text: "Guests enjoying a guided Spanish wine tasting with our sommelier",       position: 2, featured: false },
  {
    title:       "Flamenco Night Recap",
    category:    "events",
    media_type:  "video",
    video_url:   "https://www.youtube.com/embed/dQw4w9WgXcQ",
    alt_text:    "Highlights from our monthly Flamenco Night event",
    description: "An unforgettable evening of live flamenco, tapas, and fine Spanish wine.",
    position:    3,
    featured:    true
  }
].each_with_index do |attrs, i|
  GalleryItem.find_or_create_by!(title: attrs[:title], category: attrs[:category]) do |g|
    g.assign_attributes(attrs)
  end
end

puts "  Gallery items: #{GalleryItem.count}"

# ── Team Members ─────────────────────────────────────────────────────────────
puts "\nSeeding team members..."

[
  {
    name:          "Carlos Martínez",
    role:          "Head Chef & Co-founder",
    bio:           "Born in Valencia, Carlos trained under three Michelin-starred chefs before opening the restaurant in 2015. His obsession with authentic paella and the finest seasonal produce defines everything that comes out of our kitchen.",
    featured:      true,
    position:      1,
    instagram_url: "https://instagram.com/chefcarlosmartinez"
  },
  {
    name:          "Sofía Ruiz",
    role:          "Pastry Chef",
    bio:           "Sofía brings the sweet side of Spain to life with her mastery of traditional Spanish desserts. Her churros con chocolate and crema catalana have become the most requested dishes on the menu.",
    featured:      true,
    position:      2,
    instagram_url: nil
  },
  {
    name:          "Alejandro Torres",
    role:          "Head Sommelier",
    bio:           "With over fifteen years curating Spanish wine lists, Alejandro's deep knowledge of Rioja, Ribera del Duero, and Galician Albariño ensures every bottle on our list tells a story. He leads our popular monthly wine tasting evenings.",
    featured:      true,
    position:      3,
    instagram_url: "https://instagram.com/alejandrotorres_wine"
  },
  {
    name:          "Lucía Fernández",
    role:          "Restaurant Manager",
    bio:           "Lucía oversees the day-to-day experience with warmth and precision. Originally from Seville, she ensures every guest feels at home from the moment they walk through the door.",
    featured:      false,
    position:      4,
    instagram_url: nil
  },
  {
    name:          "Miguel Sánchez",
    role:          "Sous Chef",
    bio:           "Miguel's background in traditional Andalusian cooking adds depth to our tapas menu. He sources ingredients personally from local markets three mornings a week.",
    featured:      false,
    position:      5,
    instagram_url: nil
  }
].each do |attrs|
  TeamMember.find_or_create_by!(name: attrs[:name]) { |m| m.assign_attributes(attrs) }
end

puts "  Team members: #{TeamMember.count}"

# ── Business Hours ───────────────────────────────────────────────────────────
# day_of_week follows Ruby Date#wday: 0=Sunday, 1=Monday … 6=Saturday
puts "\nSeeding business hours..."

year = Date.current.year

# Regular weekly schedule
[
  { day_of_week: 0, closed: false, open_time: "12:00", close_time: "22:00", notes: "Sunday lunch service available" },
  { day_of_week: 1, closed: true,  open_time: nil,     close_time: nil,     reason: "Regular closing day" },
  { day_of_week: 2, closed: false, open_time: "13:00", close_time: "22:30" },
  { day_of_week: 3, closed: false, open_time: "13:00", close_time: "22:30" },
  { day_of_week: 4, closed: false, open_time: "13:00", close_time: "22:30" },
  { day_of_week: 5, closed: false, open_time: "13:00", close_time: "23:30", notes: "Extended Friday hours" },
  { day_of_week: 6, closed: false, open_time: "12:00", close_time: "23:30", notes: "Extended Saturday hours" }
].each do |attrs|
  BusinessHour.find_or_create_by!(day_of_week: attrs[:day_of_week], specific_date: nil) do |bh|
    bh.assign_attributes(attrs)
  end
end

# Date-specific overrides — public holidays and special days
# Owners can add more via the same table at any time
[
  # Fully closed public holidays
  { specific_date: Date.new(year, 1, 1),  reason: "New Year's Day",          closed: true },
  { specific_date: Date.new(year, 1, 6),  reason: "Epiphany (Reyes Magos)",  closed: true },
  { specific_date: Date.new(year, 5, 1),  reason: "Labour Day",              closed: true },
  { specific_date: Date.new(year, 8, 15), reason: "Assumption of Mary",      closed: true },
  { specific_date: Date.new(year, 10, 12),reason: "Spain National Day",      closed: true },
  { specific_date: Date.new(year, 11, 1), reason: "All Saints' Day",         closed: true },
  { specific_date: Date.new(year, 12, 6), reason: "Spanish Constitution Day",closed: true },
  { specific_date: Date.new(year, 12, 8), reason: "Immaculate Conception",   closed: true },
  { specific_date: Date.new(year, 12, 25),reason: "Christmas Day",           closed: true },

  # Special reduced-hour days
  {
    specific_date: Date.new(year, 12, 24),
    reason:        "Christmas Eve",
    closed:        false,
    open_time:     "12:00",
    close_time:    "18:00",
    notes:         "Early closing — last orders at 17:30"
  },
  {
    specific_date: Date.new(year, 12, 31),
    reason:        "New Year's Eve",
    closed:        false,
    open_time:     "19:00",
    close_time:    "01:00",
    notes:         "Special set-menu dinner — reservation required"
  },
  {
    specific_date: Date.new(year, 12, 26),
    reason:        "Day after Christmas",
    closed:        false,
    open_time:     "13:00",
    close_time:    "21:00",
    notes:         "Reduced hours"
  }
].each do |attrs|
  BusinessHour.find_or_create_by!(specific_date: attrs[:specific_date]) do |bh|
    bh.assign_attributes(attrs)
  end
end

puts "  Business hours (weekly): #{BusinessHour.weekly.count}"

# ── Test Reservations ─────────────────────────────────────────────────────────
# These exist purely so the payment API can be exercised immediately after seeding.
# They are skipped when a reservation with that email already exists.
puts "\nSeeding test reservations..."

# Find a date that is within open business hours (skip Mondays — closed day)
test_date = Date.current + 7
test_date += 1 while test_date.wday == 1

# ── Table-based reservation ───────────────────────────────────────────────────
unless Reservation.exists?(email: "test.table@example.com")
  table = Table.find_by(number: "T3")

  if table
    Reservation.create!(
      name:             "Test Customer",
      email:            "test.table@example.com",
      phone:            "9999999999",
      party_size:       2,
      reservation_date: test_date,
      reservation_time: "19:00",
      end_time:         "21:00",
      table:            table,
      status:           "pending",
      special_requests: "Seed reservation — table booking payment test"
    )
    r = Reservation.find_by(email: "test.table@example.com")
    puts "  Table reservation: #{r.confirmation_code} " \
         "(total ₹#{r.total_amount}, date: #{test_date})"
  else
    puts "  Table T3 not found — skipping table reservation seed"
  end
end

# ── Event-based reservation ───────────────────────────────────────────────────
unless Reservation.exists?(email: "test.event@example.com")
  event = Event.where(status: "upcoming")
               .where("event_date > ?", Date.current)
               .order(:event_date)
               .first

  if event
    Reservation.create!(
      name:             "Test Event Customer",
      email:            "test.event@example.com",
      phone:            "9999999998",
      party_size:       2,
      event:            event,
      status:           "pending",
      special_requests: "Seed reservation — event payment test"
    )
    r = Reservation.find_by(email: "test.event@example.com")
    puts "  Event reservation: #{r.confirmation_code} " \
         "(#{event.name}, total ₹#{r.total_amount})"
  else
    puts "  No upcoming events found — skipping event reservation seed"
  end
end

puts "  Total reservations: #{Reservation.count}"
