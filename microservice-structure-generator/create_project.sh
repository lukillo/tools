#!/bin/bash

echo "<- BEGIN ->"

#Initial project setup
npm update 

npm init -y 

npm install express pino body-parser dotenv http-errors -y

npm install express-http-context yamljs swagger-ui-express -y

npm install jest -D 

#Create folders and index.js
mkdir __test__ 

mkdir config && touch config/index.js

#Add data for initial server configuration
echo '
const config = {
    server: {
        port: process.env.SERVER_PORT,
        killTimeout: process.env.SERVER_KILLTIMEOUT
    },
};

module.exports = {
    ...config
};
' > config/index.js

touch .env

echo '
SERVER_PORT="8080"
SERVER_KILLTIMEOUT="180"
' > .env

mkdir src 

echo "<-- CD SRC -->"

cd src

echo "<--- creando estructura de src --->"

mkdir lib && touch lib/index.js

mkdir services && touch services/index.js

mkdir server

echo "<--- CD SERVER --->"

cd server 

echo "<---- creando estructura de server ---->"

mkdir constants && touch constants/index.js

mkdir middleware && touch middleware/index.js

mkdir controller && touch controller/index.js

mkdir routes && touch routes/index.js

touch events.js

echo '  
const process = require("process");
const config  = require("../../config");
const logger  = require("pino")();
const pkg     = require("../../package.json");

const {
    killTimeout
} = config.server;

//On server internal error.
const onServerError = ()=>logger.error({message:`Server error`});

//On server start.
const onListen = (port)=>{
    console.info(`ᕕ(ಠ‿ಠ)ᕗ ${pkg.name}`);
    logger.info(`${pkg.name}:${pkg.version} - Running on port: ${port}`);
}

//When the process receive kill signal.
const onProcessKill = server =>{
    logger.info("Service termination signal received");

    setTimeout(() => {
        logger.info("Finishing server");
        server.close(()=>process.exit(0));
    }, killTimeout);
}

//When in the server happen a uncaugth exception.
const onException = err =>logger.error({message:err});

module.exports = {
    onListen,
    onProcessKill,
    onServerError,
    onException
}; ' > events.js

touch index.js

echo '  
const http = require("http");
const httpContext = require("express-http-context");
const express = require("express");
const environment = require("dotenv").config();
const config = require("../../config");
const bodyParser = require("body-parser");

//Swagger
const swaggerUi = require("swagger-ui-express");
const YAML = require("yamljs");

//Define routes and events
const routes = require("./routes");
const events = require("./events.js");

const { port } = config.server;

//Start Express-js.
const app = express();
const server = http.createServer(app);

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//Middleware token verified
app.use(httpContext.middleware);

//Start listen mode.
app.listen(port, () => events.onListen(port));

//Define server "special" event to handle situations.
server.on("error", events.onServerError);
process.on("SIGINT", () => events.onProcessKill(server));
process.on("SIGTERM", () => events.onProcessKill(server));
process.on("unhandledRejection", events.onException);
process.on("uncaughtException", (err) => events.onException(err));' > index.js

echo "<---- CD .., Saliendo de server ---->"


cd ..

echo "<-- CD .., Saliendo de src -->"

echo "<- ENDING ->"