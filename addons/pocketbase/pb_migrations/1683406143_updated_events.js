migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6")

  // update
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
      "displayFields": [
        "study_id"
      ]
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "u6vvrt3u",
    "name": "session",
    "type": "relation",
    "required": true,
    "unique": false,
    "options": {
      "collectionId": "g9v4bjtl35w16hc",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": [
        "study_id"
      ]
    }
  }))

  return dao.saveCollection(collection)
})
