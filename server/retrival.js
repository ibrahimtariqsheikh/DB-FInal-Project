const credentials = require("./credentials");
const oracledb = require("oracledb");

async function get_paintings_available(req, res) {

    try {
        connection = await oracledb.getConnection(credentials);
        const getAvailablePaintings = await connection.execute(
            `SELECT * FROM PAINTINGS WHERE AVALAIBLE = 'Y'`);

        res.json(getAvailablePaintings.outBinds)
    }
    catch (err) {
        res.json(err.message);
    }
};

async function get_paintings_by_theme(req, res) {

    try {
        connection = await oracledb.getConnection(credentials);
        const filterByTheme = await connection.execute(
            `SELECT * FROM PAINTINGS WHERE AVALAIBLE = 'Y' AND THEME=${req.body.theme}`);

        res.json(filterByTheme.outBinds)
    }
    catch (err) {
        res.json(err.message);
    }
};

async function get_customer_info(res, id) {

    try {
        connection = await oracledb.getConnection(credentials);
        const get_customer_info = await connection.execute(
            `BEGIN
                get_customer_info(
                    :no,
                    :c_name,
                    :c_address,
                    :c_category_id,
                    :c_category_description,
                    :c_category_discount
                );
            END;`,
            {
                no: id.toString(),
                c_name: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 },
                c_address: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 },
                c_category_id: { dir: oracledb.BIND_OUT, type: oracledb.CHAR },
                c_category_description: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 },
                c_category_discount: { dir: oracledb.BIND_OUT, type: oracledb.INT }

            }

        );


        res.json(get_customer_info.outBinds)
    }
    catch (err) {
        res.json(err.message);
    }
};

async function get_painiting_info(res, id) {

    try {
        connection = await oracledb.getConnection(credentials);
        const get_customer_info = await connection.execute(
            `BEGIN
                get_painting_info(
                    :p_id,
                    :p_title,
                    :p_theme,
                    :p_rental_price,
                    :p_artist_id,
                    :p_owner_id
                );
            END;`,
            {
                p_id: id.toString(),
                p_title: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 },
                p_theme: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 },
                p_rental_price: { dir: oracledb.BIND_OUT, type: oracledb.INT },
                p_artist_id: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 },
                p_owner_id: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 }

            }

        );


        res.json(get_customer_info.outBinds)
    }
    catch (err) {
        res.json(err.message);
    }
};


async function get_artist_information(res, id) {
    try {
        connection = await oracledb.getConnection(credentials);

        const get_artist_info = await connection.execute(
            `BEGIN
                get_artist_info(
                    :no,
                    :a_name,
                    :a_country_of_birth,
                    :a_year_of_birth,
                    :a_year_of_death
                );
            END;`,
            {
                no: id.toString(),
                a_name: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 },
                a_country_of_birth: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 },
                a_year_of_birth: { dir: oracledb.BIND_OUT, type: oracledb.INT },
                a_year_of_death: { dir: oracledb.BIND_OUT, type: oracledb.INT }

            }

        );

        console.log(get_artist_info.outBinds)

        res.json(get_artist_info.outBinds);
    }
    catch (err) {
        res.json(err.message);
    }
}

async function get_owner_information(res, id) {
    try {
        connection = await oracledb.getConnection(credentials);

        const get_owner_info = await connection.execute(
            `BEGIN
             get_owner_info(
                     :no,
                     :o_name,
                     :o_address);
             END;`,
            {
                no: id.toString(),
                o_name: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 },
                o_address: { dir: oracledb.BIND_OUT, type: oracledb.VARCHAR2 }

            }

        );

        res.json(get_owner_info.outBinds)
    }
    catch (err) {
        res.json(err.message);
    }
}

async function get_c_rental_report(res, id) {
    try {
        connection = await oracledb.getConnection(credentials);

        const get_owner_info = await connection.execute(
            `BEGIN
             get_owner_info(
                     :c_no,
                     :o_name,
                     :o_address);
             END;`,
            {
                c_no: id.toString(),
            }
        );
        res.send(rental.outBinds);
    }
    catch (err) {
        res.json(err.message);
    }
}

async function testing(res) {
    try {
        connection = await oracledb.getConnection(credentials);

        const plsql = `
  DECLARE
    c1 SYS_REFCURSOR;
    c2 SYS_REFCURSOR;
  BEGIN
    OPEN c1 FOR SELECT city, postal_code
                FROM locations
                WHERE location_id < 1200;
    DBMS_SQL.RETURN_RESULT(c1);

    OPEN C2 FOR SELECT job_id, employee_id, last_name
                FROM employees
                WHERE employee_id < 103;
    DBMS_SQL.RETURN_RESULT(c2);
  END;`;

        const rental = await connection.execute(
            `BEGIN
             :ret := get_rental_report(:no)'
             END;`,
            {
                no: { dir: oracledb.BIND_IN, val: id.toString(), type: oracledb.VARCHAR2 },
                ret: { dir: oracledb.BIND_OUT, type: oracledb.TYPE, maxSize: 40 }

            }
        );
        console.log("here")
        res.send(rental.outBinds);
    }
    catch (err) {
        console.log("ERR")
        res.json(err.message);
    }
}



module.exports = { get_customer_info, get_artist_information, get_owner_information, get_painiting_info, get_c_rental_report, get_paintings_available }