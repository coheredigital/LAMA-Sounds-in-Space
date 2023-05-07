migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "uoqkic32",
    "name": "action",
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
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6")

  // remove
  collection.schema.removeField("uoqkic32")

  return dao.saveCollection(collection)
})
