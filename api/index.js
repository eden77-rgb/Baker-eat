require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const url = require('url');

const app = express();

const MYSQL_PUBLIC_URL = process.env.MYSQL_PUBLIC_URL;
const API_PORT = process.env.API_PORT;

const params = url.parse(MYSQL_PUBLIC_URL);
const [user, password] = params.auth.split(':');

async function getData() {
    const connection = await mysql.createConnection({
        host: params.hostname,
        user: user,
        password: password,
        database: params.pathname.replace('/', ''),
        port: Number(params.port),
        ssl: {
            rejectUnauthorized: false
        }
    });

    try {
        
        const rows = await connection.execute('SELECT * FROM boulangerie');

        if (rows.length === 0) {
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
        await connection.end();
    }
}

app.get("/boulangerie", async (req, res) => {
    const data = await getData()
    res.json(data);
})

app.listen(API_PORT, () => {
    console.log(`Server running on port ${API_PORT}`);
})
