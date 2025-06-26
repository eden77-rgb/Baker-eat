/* API : https://api-nodejs-production-c1fe.up.railway.app/boulangeries/getData */

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

const allowedTables = ['boulangeries', 'boulangeries_produits', 'paniers_produits', 'paniers', 'produits'];

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

async function getDataPos(lat, lon) {
    const db = await initDB(params);

    try {
        const [rows] = await db.execute(`
            SELECT
                id,
                nom,
                description,
                image,
                adresse,
                latitude,
                longitude,
                (
                    6371 * acos(
                        cos(radians(?)) *
                        cos(radians(latitude)) *
                        cos(radians(longitude) - radians(?)) +
                        sin(radians(?)) *
                        sin(radians(latitude))
                    )
                ) AS distance_km
            FROM boulangeries
            HAVING distance_km < 5
            ORDER BY distance_km ASC
        `, [lat, lon, lat]);

        if (rows.length == 0) {
            console.log("Aucune boulangerie trouvée autour de cette position");
            return [];
        } 
        
        else {
            return rows;
        }
    } 
    
    catch (err) {
        console.error('Erreur lors de la requête géolocalisation:', err);
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

async function getProduit() {
    const db = await initDB(params);

    try {
        const [rows] = await db.execute(`
            SELECT 
                pp.id AS id,
                pp.panier_id,
                pp.boulangerie_produit_id,
                pp.quantite,
                b.nom AS boulangerie,
                p.nom AS produit,
                bp.prix,
                (bp.prix * pp.quantite) AS prix_total
            FROM paniers_produits pp
            JOIN boulangeries_produits bp 
                ON pp.boulangerie_produit_id = bp.id
            JOIN boulangeries b 
                ON bp.boulangerie_id = b.id
            JOIN produits p 
                ON bp.produit_id = p.id

        `);

        return rows;
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

async function postDeletePanier(id_panier) {
    const db = await initDB(params);

    try {
        await db.execute(`DELETE FROM paniers_produits WHERE panier_id = ?`, [id_panier]);
        return { success: true };
    } 
    
    catch (err) {
        console.error("Erreur lors de la suppression des produits du panier :", err);
        return { success: false };
    } 
    
    finally {
        await db.end();
    }
}

async function postDeletePanierProduit(id_produit) {
    const db = await initDB(params);

    try {
        await db.execute(`DELETE FROM paniers_produits WHERE id = ?`, [id_produit]);
        return { success: true };
    } 
    
    catch (err) {
        console.error("Erreur lors de la suppression du produit du panier :", err);
        return { success: false };
    } 
    
    finally {
        await db.end();
    }
    
}

// Routes
app.get("/boulangeries/getData", async (request, result) => {
    const data = await getData("boulangeries");

    result.json(data);
})

app.get("/boulangeries/getDataId/", async (request, result) => {
    const id = request.query.id;
    const data = await getDataId("boulangeries", id);

    result.json(data);
})

app.get("/boulangeries/getDataPos", async (request, result) => {
    const lat = request.query.lat
    const lon = request.query.lon
    const data = await getDataPos(lat, lon)

    result.json(data)
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


app.get("/paniers_produits/getDada", async (request, result) => {
    const data = await getData("paniers_produits");

    result.json(data);
})

app.get("/paniers_produits/getDadaId", async (request, result) => {
    const id = request.query.id
    const data = await getDataId("paniers_produits", id)

    result.json(data);
})

app.get("/paniers_produits/getProduit", async (request, result) => {
    const data = await getProduit()

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

app.post("/paniers_produits/supprimer", async (req, res) => {
    const { id_produit } = req.body;

    if (!id_produit) {
        return res.status(400).json({ message: "ID du produit manquant" })
    }

    try {
        const result = await postDeletePanierProduit(id_produit)
        res.status(200).json({ message: "Produit supprimé du panier", result })
    } 
    
    catch (err) {
        res.status(500).json({ message: "Erreur serveur" })
    }
})

app.post("/paniers/supprimerProduits", async (req, res) => {
    const { id_panier } = req.body

    if (!id_panier) {
        return res.status(400).json({ message: "ID du panier manquant" })
    }

    try {
        const result = await postDeletePanier(id_panier)
        res.status(200).json({ message: "Produits du panier supprimés", result })
    } 
    
    catch (err) {
        res.status(500).json({ message: "Erreur serveur" })
    }
})


app.listen(API_PORT, () => {
    console.log(`Server running on port ${API_PORT}`);
})
