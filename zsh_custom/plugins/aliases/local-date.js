const date = new Date(process.argv[2])
console.log( date.toLocaleString('en-US', {timeZone: 'America/New_York'}) );
