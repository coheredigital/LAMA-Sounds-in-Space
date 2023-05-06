migrate((db) => {
  const collection = new Collection({
    "id": "g9v4bjtl35w16hc",
    "created": "2023-05-06 20:36:43.063Z",
    "updated": "2023-05-06 20:36:43.063Z",
    "name": "sessions",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "bvjteowv",
        "name": "study_id",
        "type": "text",
        "required": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "fh5ahs7z",
        "name": "age_group",
        "type": "text",
        "required": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "ue0rjfb3",
        "name": "run_id",
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
  const collection = dao.findCollectionByNameOrId("g9v4bjtl35w16hc");

  return dao.deleteCollection(collection);
})
