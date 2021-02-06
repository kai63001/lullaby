import Server from './controller/server';
import Db from './connection/db';
const server = new Server(3000);
const db = new Db();