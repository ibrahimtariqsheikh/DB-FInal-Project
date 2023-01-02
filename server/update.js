const credentials = require("./credentials");
const oracledb = require("oracledb");


async function update_customer(req, res) {
    try {

        console.log(req.body)

        connection = await oracledb.getConnection(credentials);
        await connection.execute(
            `BEGIN
            UPDATE_CUSTOMER(
                    :customer_no,
                    :customer_name,
                    :customer_address
                );
            END;`,
            {
                customer_no: req.body.customer_no,
                customer_name: req.body.customer_name,
                customer_address: req.body.customer_address
            }

        );
        res.json(`Customer ${req.body.customer_name} is updated successfully`);
        connection.commit();

    }
    catch (err) {
        console.log("error: " + err.message);
        res.json(err.message);
    }
}

async function update_artist(req, res) {
    try {

        console.log(req.body)

        connection = await oracledb.getConnection(credentials);
        await connection.execute(
            `BEGIN
            UPDATE_ARTIST(
                    :artist_id,
                    :artist_name,
                    :country_of_birth,
                    :year_of_birth,
                    :year_of_death
                );
            END;`,
            {
                artist_id: req.body.artist_id,
                artist_name: req.body.artist_name,
                country_of_birth: req.body.country_of_birth,
                year_of_birth: req.body.year_of_birth,
                year_of_death: req.body.year_of_death
            }

        );
        res.json(` Artist ${req.body.artist_name} is updated successfully`);
        connection.commit();

    }
    catch (err) {
        console.log("error: " + err.message);
        res.json(err.message);
    }
}

async function update_owner(req, res) {
    try {

        console.log(req.body)

        connection = await oracledb.getConnection(credentials);
        await connection.execute(
            `BEGIN
            UPDATE_OWNER(
                    :owner_id,
                    :owner_name,
                    :owner_address,
                    :owner_tel
                );
            END;`,
            {
                owner_id: req.body.owner_id,
                owner_name: req.body.owner_name,
                owner_address: req.body.owner_name,
                owner_tel: req.body.owner_tel
            }

        );
        connection.commit();
        res.json(`Owner ${req.body.owner_name} is updated successfully`);

    }
    catch (err) {
        console.log("error: " + err.message);
        res.json(err.message);
    }
}


async function update_painting(req, res) {
    try {

        connection = await oracledb.getConnection(credentials);
        await connection.execute(
            `BEGIN
            UPDATE_PAINTING(
                    :PAINTING_ID,
                    :PAINTING_TITLE,
                    :THEME,
                    :RENTAL_PRICE,
                    :ARTIST_ID,
                    :OWNER_ID
                );
            END;`,
            {
                PAINTING_ID: req.body.PAINTING_ID,
                PAINTING_TITLE: req.body.PAINTING_TITLE,
                THEME: req.body.THEME,
                RENTAL_PRICE: req.body.RENTAL_PRICE,
                ARTIST_ID: req.body.ARTIST_ID,
                OWNER_ID: req.body.OWNER_ID
            }

        );
        connection.commit();
        res.json(`Painting ${req.body.PAINTING_TITLE} is updated successfully`);

    }
    catch (err) {
        console.log("error: " + err.message);
        res.json(err.message);
    }
}


async function return_painting(res, id) {
    try {

        connection = await oracledb.getConnection(credentials);
        data = await connection.execute(`BEGIN
        RETURN_PAINTING(
                :p_no
                );
        END;`, {
            p_no: id.toString()
        });
        connection.commit();

    }
    catch (err) {
        console.log("error: " + err.message);
        res.json(err.message);
    }
}

module.exports = {
    update_customer,
    update_artist,
    update_owner,
    update_painting
};