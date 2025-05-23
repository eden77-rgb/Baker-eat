/* API : https://api-nodejs-production-c1fe.up.railway.app/boulangerie */

require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const url = require('url');

const app = express();

const MYSQL_PUBLIC_URL = process.env.MYSQL_PUBLIC_URL;
const API_PORT = process.env.API_PORT;

const params = url.parse(MYSQL_PUBLIC_URL);
const [user, password] = params.auth.split(':');

async function initDB(params) {
    return await mysql.createConnection({
        host: params.hostname,
        user: user,
        password: password,
        database: params.pathname.replace('/', ''),
        port: Number(params.port),
        ssl: {
            rejectUnauthorized: false
        }
    });
}

async function getData() {
    const db = await initDB(params) 

    try {
        
        const rows = await db.execute('SELECT * FROM boulangerie');

        if (rows.length == 0) {
            console.log("Aucun utilisateur trouvé avec cet ID");
        }

        else {
            return rows[0];
        }
    }
    
    catch (err) {
        console.error('Erreur lors de la requête:', err);
        return [];
    } 
    
    finally {
        await db.end();
    }
}

async function getDataId(id) {
    const db = await initDB(params) 

    try {
        
        const rows = await db.execute('SELECT * FROM boulangerie WHERE id = ?', [id]);

        if (rows.length == 0) {
            console.log("Aucun utilisateur trouvé avec cet ID");
        }

        else {
            return rows[0];
        }
    }
    
    catch (err) {
        console.error('Erreur lors de la requête:', err);
        return [];
    } 
    
    finally {
        await db.end();
    }
}

app.get("/boulangerie", async (request, result) => {
    const id = request.query.id;
    const data = id ? await getDataId(id) : await getData()

    result.json(data);
})

app.listen(API_PORT, () => {
    console.log(`Server running on port ${API_PORT}`);
})
