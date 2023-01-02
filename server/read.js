const credentials = require("./credentials");
const oracledb = require("oracledb");

async function read_customers(res) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM CUSTOMER ORDER BY CUSTOMER_NO`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_customer(res, id) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM CUSTOMER WHERE CUSTOMER_NO='${id}'`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_painting(res, id) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`Select * from paintings WHERE PAINTING_ID='${id}'`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_paintings(res) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM PAINTINGS ORDER BY PAINTING_ID`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_available_paintings(res) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM PAINTINGS WHERE AVAILABLE='Y'`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_owner(res, id) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM OWNER WHERE OWNER_ID ='${id}'`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_owners(res) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM OWNER ORDER BY OWNER_ID`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_category(res) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM CATEGORY`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_artists(res) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM ARTIST ORDER BY ARTIST_ID`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_artist(res, id) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM ARTIST WHERE ARTIST_ID ='${id}'`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_rentals(res) {
    try {
        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`SELECT * FROM RENTAL_REPORT ORDER BY CUSTOMER_NO`)
        res.json(data.rows)
    }
    catch (err) {
        res.json(err.message);
    }
}


async function read_artist_report(res, id) {
    try {

        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`BEGIN
        GET_ARTIST_REPORT(
                :a_no);
        END;`, {
            a_no: id.toString()
        });
        res.json(data.implicitResults);
    }
    catch (err) {
        res.json(err.message);
    }
}

async function read_customer_rental_report(res, id) {
    try {

        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`BEGIN
        GET_CUSTOMER_RENTAL(
                :c_no);
        END;`, {
            c_no: id.toString()
        });
        res.json(data.implicitResults);
    }
    catch (err) {
        res.json(err.message);
    }
}

async function get_owner_report(res, id) {
    try {

        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`BEGIN
        RETURN_TO_OWNER_REPORT(
                :o_no);
        END;`, {
            o_no: id.toString()
        });
        res.json(data.implicitResults);
    }
    catch (err) {
        res.json(err.message);
    }
}

module.exports = {
    read_customers,
    read_paintings,
    read_owners,
    read_category,
    read_artists,
    read_customer,
    read_painting,
    read_owner,
    read_artist,
    read_artist_report,
    read_customer_rental_report,
    get_owner_report,
    read_rentals,
    read_available_paintings
};