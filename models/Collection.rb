class Collection < Sequel::Model(:Collection)
  def getItems()
    items = Item.where(:collection_fk => self.id)
    return items
  end
end
