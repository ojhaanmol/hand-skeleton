const fs = require('fs');
const path= require('path');
const http = require('http');
const WebSocket = require('ws');

const server = http.createServer();
const wss = new WebSocket.Server({ server });

const FILE= path.resolve(__dirname, '../.volumes/hand.csv')

wss.on('connection', (ws) => {

	const fileData=fs.readFileSync(FILE, 'utf8'); 
	const records= fileData.split('\n');
	const lastRecord= records[ records.length -2 ]
	ws.send( lastRecord );

	fs.watch(FILE, () => {
		const fileData=fs.readFileSync(FILE, 'utf8'); 
		const records= fileData.split('\n');
		const lastRecord= records[ records.length -2 ];
	    ws.send( lastRecord );
	});

});

server.listen(3000, () => console.log('Running on http://localhost:3000'));

