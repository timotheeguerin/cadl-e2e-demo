import { Container, CosmosClient, Database, Resource } from "@azure/cosmos";

interface Comment {
  id: string;
  contents: string;
  sentiment: string;
}

class EntityStore<T, TKeyField extends string = never> {
  private client: CosmosClient;
  private databaseId: string;
  private collectionId: string;
  private container!: Container;
  private database!: Database;
  constructor(client: CosmosClient, databaseId: string, collectionId: string) {
    this.client = client;
    this.databaseId = databaseId;
    this.collectionId = collectionId;
  }

  async init() {
    const { database } = await this.client.databases.createIfNotExists({
      id: this.databaseId,
    });
    const { container } = await database.containers.createIfNotExists({
      id: this.collectionId,
    });
    this.database = database;
    this.container = container;
  }

  async get(id: string): Promise<(T & Resource) | undefined> {
    const { resource } = await this.container.item(id).read();
    return resource;
  }

  async find(query: string): Promise<(T & Resource)[]> {
    const { resources } = await this.container.items.query(query).fetchAll();
    return resources;
  }

  async findWhere(predicate: string): Promise<(T & Resource)[]> {
    const { resources } = await this.container.items
      .query(`select * from ${this.collectionId} where ${predicate}`)
      .fetchAll();
    return resources;
  }

  async findAll(): Promise<(T & Resource)[]> {
    return this.find(`select * from ${this.collectionId}`);
  }

  async add(item: Omit<T, TKeyField>): Promise<T & Resource> {
    const { resource } = await this.container.items.create(item);
    return resource! as T & Resource;
  }

  async update(
    id: string,
    updatedItem: Omit<T, TKeyField>
  ): Promise<T & Resource> {
    const { resource } = await this.container.item(id).replace(updatedItem);
    return resource! as T & Resource;
  }

  async delete(id: string): Promise<void> {
    await this.container.item(id).delete();
  }
}

export class DataStore {
  private client: CosmosClient;
  public Comment: EntityStore<Comment, "id">;
  constructor(connectionString: string) {
    this.client = new CosmosClient(connectionString);
    this.Comment = new EntityStore<Comment, "id">(
      this.client,
      "dbName",
      "Comment"
    );
  }

  async init() {
    await Promise.all([this.Comment.init()]);
  }
}
