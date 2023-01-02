const express = require('express')
const app = express()
const oracledb = require('oracledb');
const cors = require('cors');
const { add_category, add_customer, add_owner, add_artist, add_painting, add_rental } = require('./addData.js');
const { read_customers, read_paintings, read_owners, read_category, read_artists, read_customer, read_painting, read_rentals, read_owner, read_artist,
    read_customer_rental_report, read_artist_report, get_owner_report, read_available_paintings } = require("./read.js");
const { update_customer, update_artist, update_rental, update_owner, update_painting } = require('./update.js');

require('dotenv').config()


oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
app.use(express.json())
app.use(cors())


app.get('/', (req, res) => {
    res.json("connected to add")
});

//category

app.post('/category', async (req, res) => {
    await add_category(res);
})

app.get('/category', async (req, res) => {
    await read_category(res);
})

//customer

app.get('/customer', async (req, res) => {
    await read_customers(res);
})

app.get('/customer/:id', async (req, res) => {
    id = req.params.id;
    await read_customer(res, id);
})

app.put('/customer', async (req, res) => {
    await update_customer(req, res);
})

app.get('/customer-report/:id', async (req, res) => {
    id = req.params.id;
    await read_customer_rental_report(res, id);
})

app.post('/customer', async (req, res) => {
    console.log(req.body)
    await add_customer(req, res);
})

//owner

app.post('/owner', async (req, res) => {
    await add_owner(req, res);
})

app.get('/owner-report/:id', async (req, res) => {
    id = req.params.id;
    await get_owner_report(res, id);
})

app.get('/owner', async (req, res) => {
    await read_owners(res);
})

app.get('/owner/:id', async (req, res) => {
    id = req.params.id;
    await read_owner(res, id);
})

app.put('/owner', async (req, res) => {
    await update_owner(req, res);
})

//artist

app.post('/artist', async (req, res) => {
    await add_artist(req, res);
})

app.get('/artist', async (req, res) => {
    await read_artists(res);
})

app.get('/artist-report/:id', async (req, res) => {
    id = req.params.id;
    await read_artist_report(res, id);
})

app.get('/artist/:id', async (req, res) => {
    id = req.params.id;
    console.log(id);
    await read_artist(res, id);
})

app.put('/artist', async (req, res) => {
    console.log(req.body);
    await update_artist(req, res);
})

//paintings

app.post('/painting', async (req, res) => {
    console.log(req.body);
    await add_painting(req, res);
})

app.get('/painting', async (req, res) => {
    await read_paintings(res);
})

app.get('/painting/available', async (req, res) => {
    await read_available_paintings(res);
})

app.get('/painting/:id', async (req, res) => {
    id = req.params.id;
    await read_painting(res, id);
})


app.put('/painting', async (req, res) => {
    console.log(req.body)
    await update_painting(req, res);
})

//rental

app.get('/rental', async (req, res) => {
    await read_rentals(res)
})

/*
app.get('/rental/:id', async (req, res) => {
    id = req.params.id;
    await read_rental(res, id)
})
*/

app.put('/rental/:id', async (req, res) => {
    id = req.params.id;
    await update_rental(res, id)
})

app.post('/rental', async (req, res) => {
    await add_rental(req, res);
})



app.get('/getCustomerRentalReportTest/:id', async (req, res) => {
    id = req.params.id;
    await test(res, id);
})

app.get('/update-rental/:id', async (req, res) => {
    id = req.params.id;
    console.log(id)
    await update_rental(res, id);
})

app.listen(process.env.PORT, () => {
    console.log(`listening on port ${process.env.PORT}`)
})

