class TableSerializer
  def self.render(table)
    {
      id:           table.id,
      number:       table.number,
      capacity:     table.capacity,
      min_capacity: table.min_capacity,
      location:     table.location,
      notes:        table.notes,
      total_amount: table.price.to_f
    }
  end
end
