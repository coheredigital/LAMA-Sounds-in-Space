migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "zfsrmuhv",
    "name": "info",
    "type": "text",
    "required": true,
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

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "zfsrmuhv",
    "name": "label",
    "type": "text",
    "required": true,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
})
