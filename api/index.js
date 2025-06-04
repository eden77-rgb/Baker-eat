/* API : https://api-nodejs-production-c1fe.up.railway.app/boulangerie/getData */

require('dotenv').config();
const express = require('express');
const { request } = require('http');
const mysql = require('mysql2/promise');
const url = require('url');

const app = express();

const MYSQL_PUBLIC_URL = process.env.MYSQL_PUBLIC_URL;
const API_PORT = process.env.API_PORT;

const params = url.parse(MYSQL_PUBLIC_URL);
const [user, password] = params.auth.split(':');

const allowedTables = ['boulangeries', 'produits', 'boulangeries_produits'];

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

async function getData(table) {
    if (!allowedTables.includes(table)) {
        throw new Error('Table non autorisée');
    }

    const db = await initDB(params)

    try {

        const rows = await db.execute(`SELECT * FROM ${table}`);

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

async function getDataId(table, id) {
    if (!allowedTables.includes(table)) {
        throw new Error('Table non autorisée');
    }

    const db = await initDB(params)

    try {

        const rows = await db.execute(`SELECT * FROM ${table} WHERE id = ?`, [id]);

        if (rows.length == 0) {
            console.log("Aucun donnée trouvé avec cet ID");
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

async function getPrix(id) {
    const db = await initDB(params)

    try {

        const rows = await db.execute(`
            SELECT 
                bp.id AS id,
                b.nom AS boulangerie,
                p.nom AS produit,
                bp.prix,
                bp.disponible
            FROM boulangeries b
            JOIN boulangeries_produits bp
                ON b.id = bp.boulangerie_id
            JOIN produits p
                ON p.id = bp.produit_id
            WHERE p.id = ?
        `, [id]);


        if (rows.length == 0) {
            console.log("Aucun donnée trouvé avec cet ID");
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

async function postProduitsPanier(panier_id, boulangerie_produit_id, quantite) {
    const db = await initDB(params)

    try {

        const rows = await db.execute(`
            INSERT INTO paniers_produits (panier_id, boulangerie_produit_id, quantite)
            VALUES (?, ?, ?)
        `, [panier_id, boulangerie_produit_id, quantite]);


        if (rows.length == 0) {
            console.log("Aucun donnée trouvé avec cet ID");
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

app.get("/boulangeries/getData", async (request, result) => {
    const data = await getData("boulangeries");

    result.json(data);
})

app.get("/boulangeries/getDataId/", async (request, result) => {
    const id = request.query.id;
    const data = await getDataId("boulangeries", id);

    result.json(data);
})


app.get("/produits/getData", async (request, result) => {
    const data = await getData("produits");

    result.json(data);
})

app.get("/produits/getDataId/", async (request, result) => {
    const id = request.query.id;
    const data = await getDataId("produits", id);

    result.json(data);
})


app.get("/boulangeries_produits/getData", async (request, result) => {
    const data = await getData("boulangeries_produits");

    result.json(data);
})

app.get("/boulangeries_produits/getDataId/", async (request, result) => {
    const id = request.query.id;
    const data = await getDataId("boulangeries_produits", id);

    result.json(data);
})

app.get("/boulangeries_produits/getPrix/", async (request, result) => {
    const id = request.query.id;
    const data = await getPrix(id);

    result.json(data);
})

app.use(express.json());

app.post("/paniers_produits/ajouter", async (req, res) => {
    const { panier_id, boulangerie_produit_id, quantite } = req.body

    if (!panier_id || !boulangerie_produit_id || !quantite) {
        return res.status(400).json({ message: "Champs manquants" });
    }

    try {
        const result = await postProduitsPanier(panier_id, boulangerie_produit_id, quantite)
        res.status(201).json({ message: "Produit ajouté au panier", result })
    }

    catch (err) {
        console.error("Erreur lors de l'ajout au panier :", err)
        res.status(500).json({ message: "Erreur serveur" });
    }
})

app.listen(API_PORT, () => {
    console.log(`Server running on port ${API_PORT}`);
})
