const credentials = require("./credentials");
const oracledb = require("oracledb");
const { v4: uuidv4 } = require('uuid');

async function add_category(res) {

    try {
        connection = await oracledb.getConnection(credentials);
        const data = await connection.execute(`Select * from category`, [], {
            resultSet: true,
            outFormat: oracledb.OUT_FORMAT_OBJECT
        });
        while ((row = await data.resultSet.getRow())) {
            console.log(row)
        }
        res.send("done")
    }
    catch (err) {
        console.log(err);
    }
};


async function add_customer(req, res) {
    try {

        console.log(req.body);
        connection = await oracledb.getConnection(credentials);

        const data = await connection.execute(
            `BEGIN
             add_customer(
                     :no,
                     :cname,
                     :caddress
                     );
             END;`,
            {
                no: uuidv4(),
                cname: req.body.cname,
                caddress: req.body.caddress
            }
        );
        connection.commit();
    }
    catch (err) {
        console.log(err.message)
    }
}

async function add_owner(req, res) {
    try {
        connection = await oracledb.getConnection(credentials);
        console.log(req.body);

        const data = await connection.execute(
            `BEGIN
             add_owner(
                     :no,
                     :o_name,
                     :o_address,
                     :o_tel
                     );
             END;`,
            {
                no: uuidv4(),
                o_name: req.body.o_name,
                o_address: req.body.o_address,
                o_tel: req.body.o_tel
            }
        );
        connection.commit();
        console.log("done")
        res.json("Owner Added")
    }
    catch (err) {
        console.log(err.message)
        res.json(err.message);
    }
}

async function add_artist(req, res) {
    try {
        connection = await oracledb.getConnection(credentials);

        const data = await connection.execute(
            `BEGIN
             add_artist(
                     :no,
                     :a_name,
                     :a_country_of_birth,
                     :a_year_of_birth,
                     :a_year_of_death
                     );
             END;`,
            {
                no: uuidv4(),
                a_name: req.body.a_name,
                a_country_of_birth: req.body.a_country_of_birth,
                a_year_of_birth: req.body.a_year_of_birth,
                a_year_of_death: req.body.a_year_of_death
            }
        );
        connection.commit();
        res.json("Artist Added")
    }
    catch (err) {
        res.json(err.message);
    }
}

async function add_painting(req, res) {
    try {
        connection = await oracledb.getConnection(credentials);

        const data = await connection.execute(
            `BEGIN add_painting(
                :p_id,
                :p_title,
                :p_theme,
                :p_rental_price,
                :p_artist_id ,
                :p_owner_id);
                END;`,
            {
                p_id: uuidv4(),
                p_title: req.body.p_title,
                p_theme: req.body.p_theme,
                p_rental_price: req.body.p_rental_price,
                p_artist_id: req.body.p_artist_id,
                p_owner_id: req.body.p_owner_id
            }
        );
        connection.commit();
        console.log("Painting Added")
        res.json("Painting Added")
    }
    catch (err) {
        console.log(err.message)
        res.json(err.message);
    }
}

async function add_rental(req, res) {
    try {
        connection = await oracledb.getConnection(credentials);

        const data = await connection.execute(
            `BEGIN add_rental(
                :customer_no,
                :painting_id,
                :due_date_back);
                END;`,
            {
                customer_no: req.body.customer_no,
                painting_id: req.body.painting_id,
                due_date_back: req.body.due_date_back
            }
        );
        connection.commit();
        console.log("Rental Added")
        res.json("Rental Added")
    }
    catch (err) {
        console.log("Rental Added Error" + err.message)
        res.json(err.message);
    }
}



module.exports = { add_category, add_customer, add_owner, add_artist, add_painting, add_rental };