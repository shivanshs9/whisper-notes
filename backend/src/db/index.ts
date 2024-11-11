import { DataSource } from "typeorm"
import { Note } from "../entity/note"
import "reflect-metadata"
import { resolve } from "node:path";

const ROOT_PATH = resolve(__dirname, "../..")

export const DB = new DataSource({
    type: !!process.env.DB_USERNAME ? "postgres" : "sqlite",
    host: process.env.DB_HOST || "localhost",
    port: parseInt(process.env.DB_PORT || "3306"),
    username: process.env.DB_USERNAME || "test",
    password: process.env.DB_PASSWORD || "test",
    database: process.env.DB_NAME || `${ROOT_PATH}/db.sqlite`,
    entities: [ Note ],
    logging: true,
    synchronize: true,
})

export const InitializeDb = () => {
    DB.initialize().then(() => {
        console.log("Successful DB connection.")
    }).catch((err) => {
        console.error("Error in DB connection: ", err)
        process.exit(1)
    })
}