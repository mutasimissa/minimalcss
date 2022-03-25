const minimalcss = require('minimalcss');
const express = require('express');
const app = express();
const cors = require("cors");
const bodyParser = require("body-parser");
const morgan = require("morgan");

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(morgan("dev"));

app.get('/', async (req, res) => {
    res.send({
        message: `server running`
    })
})
app.post('/', async (req, res) => {
    let urls = req.body.urls;
    try {
        const result = await minimalcss.minimize({
            urls: urls,
            ignoreCSSErrors: true,
            ignoreJSErrors: true,
            ignoreRequestErrors: true,
            puppeteerArgs: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        res.send(result.finalCss)
    } catch (error) {
        res.send(`Failed the minimize CSS: ${error}`);
    }

});

app.listen(4000, () => {
    console.log('listening to port 4000...');
});
