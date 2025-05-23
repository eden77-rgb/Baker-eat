const mysql = require('mysql2/promise');
const url = require('url');

const MYSQL_PUBLIC_URL = '';

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
        
        const rows = await connection.execute('SELECT * FROM boulangerie WHERE id = ?', [1]);

        if (rows.length === 0) {
            console.log("Aucun utilisateur trouvé avec cet ID");
        } 
        
        else {
            console.log(rows[0]);
        }
    } 
    
    catch (err) {
        console.error('Erreur lors de la requête:', err);
    } 
    
    finally {
        await connection.end();
        console.log("Connexion terminée");
    }
}

getData();
