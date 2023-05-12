migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("g9v4bjtl35w16hc")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "vjta9s9e",
    "name": "folder",
    "type": "text",
    "required": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("g9v4bjtl35w16hc")

  // remove
  collection.schema.removeField("vjta9s9e")

  return dao.saveCollection(collection)
})
