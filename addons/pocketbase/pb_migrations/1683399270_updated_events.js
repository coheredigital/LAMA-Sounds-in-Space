migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6")

  // remove
  collection.schema.removeField("lki2v4cl")

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "lki2v4cl",
    "name": "time",
    "type": "date",
    "required": false,
    "unique": false,
    "options": {
      "min": "",
      "max": ""
    }
  }))

  return dao.saveCollection(collection)
})
