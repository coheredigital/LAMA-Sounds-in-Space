migrate((db) => {
  const collection = new Collection({
    "id": "i0w6a9rm86kyho6",
    "created": "2023-05-06 18:08:24.299Z",
    "updated": "2023-05-06 18:08:24.299Z",
    "name": "events",
    "type": "base",
    "system": false,
    "schema": [
      {
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
      },
      {
        "system": false,
        "id": "zfsrmuhv",
        "name": "label",
        "type": "text",
        "required": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("i0w6a9rm86kyho6");

  return dao.deleteCollection(collection);
})
