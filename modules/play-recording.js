const fs= require('fs');

let record=0;

setInterval(()=>{

    const recordingFile= fs.readFileSync( '.volumes/recording.csv', {encoding: 'utf-8'} );
    const playFileLocation= '.volumes/hand.csv';

    const currentFrame= recordingFile.split('\n')[record];
    fs.appendFileSync( playFileLocation, currentFrame+'\n' );

    record++;

}, 100);