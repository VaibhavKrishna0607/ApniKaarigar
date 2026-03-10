const fs = require('fs'), path = require('path'), os = require('os');
const apiSrc = fs.readFileSync(path.join(os.homedir(), 'AppData/Roaming/npm/node_modules/firebase-tools/lib/api.js'), 'utf8');
const cid = apiSrc.match(/FIREBASE_CLIENT_ID[^,]+,\s*"([^"]+)"/)[1];
const cse = apiSrc.match(/FIREBASE_CLIENT_SECRET[^,]+,\s*"([^"]+)"/)[1];
const fbCfg = JSON.parse(fs.readFileSync(path.join(os.homedir(), '.config/configstore/firebase-tools.json'), 'utf8'));
const rt = fbCfg.tokens.refresh_token;
fetch('https://oauth2.googleapis.com/token', {
  method: 'POST',
  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  body: new URLSearchParams({client_id: cid, client_secret: cse, refresh_token: rt, grant_type: 'refresh_token'})
}).then(r => r.json()).then(t => {
  return fetch('https://storage.googleapis.com/storage/v1/b?project=apnakaarigar-5c619', {
    headers: {Authorization: 'Bearer ' + t.access_token}
  }).then(r => r.json()).then(d => {
    console.log('Buckets:', JSON.stringify(d.items ? d.items.map(b => b.name) : d, null, 2));
  });
}).catch(console.error);
