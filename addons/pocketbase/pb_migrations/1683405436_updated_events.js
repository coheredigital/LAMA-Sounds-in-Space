migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "u6vvrt3u",
    "name": "session",
    "type": "relation",
    "required": false,
    "unique": false,
    "options": {
      "collectionId": "g9v4bjtl35w16hc",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": []
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6")

  // remove
  collection.schema.removeField("u6vvrt3u")

  return dao.saveCollection(collection)
})
