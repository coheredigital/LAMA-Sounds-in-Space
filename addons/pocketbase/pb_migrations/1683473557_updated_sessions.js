migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("g9v4bjtl35w16hc")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "ekog3zkq",
    "name": "events",
    "type": "relation",
    "required": false,
    "unique": false,
    "options": {
      "collectionId": "i0w6a9rm86kyho6",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": null,
      "displayFields": []
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("g9v4bjtl35w16hc")

  // remove
  collection.schema.removeField("ekog3zkq")

  return dao.saveCollection(collection)
})
