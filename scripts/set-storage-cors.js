// Tries multiple bucket name variants and applies CORS to whichever one responds OK
const fs = require('fs'), path = require('path'), os = require('os');

const PROJECT = 'apnakaarigar-5c619';
const BUCKET_CANDIDATES = [
  `${PROJECT}.firebasestorage.app`,
  `${PROJECT}.appspot.com`,
];

const CORS = [{
  origin: [
    'http://localhost',
    'http://localhost:*',
    'https://apnakaarigar-5c619.web.app',
    'https://apnakaarigar-5c619.firebaseapp.com',
  ],
  method: ['GET', 'PUT', 'POST', 'DELETE', 'HEAD', 'OPTIONS'],
  maxAgeSeconds: 3600,
  responseHeader: [
    'Content-Type', 'Authorization', 'Content-Length',
    'User-Agent', 'x-goog-resumable', 'x-goog-meta-firebaseStorageDownloadTokens',
  ],
}];

const apiSrc = fs.readFileSync(
  path.join(os.homedir(), 'AppData/Roaming/npm/node_modules/firebase-tools/lib/api.js'), 'utf8');
const cid = apiSrc.match(/FIREBASE_CLIENT_ID[^,]+,\s*"([^"]+)"/)[1];
const cse = apiSrc.match(/FIREBASE_CLIENT_SECRET[^,]+,\s*"([^"]+)"/)[1];
const fbCfg = JSON.parse(
  fs.readFileSync(path.join(os.homedir(), '.config/configstore/firebase-tools.json'), 'utf8'));
const rt = fbCfg.tokens.refresh_token;

(async () => {
  const tokenRes = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: new URLSearchParams({
      client_id: cid, client_secret: cse, refresh_token: rt, grant_type: 'refresh_token',
    }),
  });
  const {access_token: tok} = await tokenRes.json();
  if (!tok) throw new Error('Could not get access token');
  console.log('Token OK');

  for (const bucket of BUCKET_CANDIDATES) {
    console.log(`\nTrying bucket: ${bucket}`);

    const getRes = await fetch(
      `https://storage.googleapis.com/storage/v1/b/${encodeURIComponent(bucket)}?fields=name,cors`,
      {headers: {Authorization: `Bearer ${tok}`}});
    const getJson = await getRes.json();

    if (!getRes.ok) {
      console.log(`  GET ${getRes.status}: ${getJson?.error?.message}`);
      continue;
    }
    console.log(`  Found bucket: ${getJson.name}`);
    console.log(`  Current CORS: ${JSON.stringify(getJson.cors ?? [])}`);

    const patchRes = await fetch(
      `https://storage.googleapis.com/storage/v1/b/${encodeURIComponent(bucket)}`,
      {
        method: 'PATCH',
        headers: {Authorization: `Bearer ${tok}`, 'Content-Type': 'application/json'},
        body: JSON.stringify({cors: CORS}),
      });
    const patchJson = await patchRes.json();

    if (patchRes.ok) {
      console.log('\n✓  CORS configured successfully!');
      console.log('New CORS:', JSON.stringify(patchJson.cors ?? CORS, null, 2));
      return;
    } else {
      console.log(`  PATCH ${patchRes.status}: ${patchJson?.error?.message}`);
    }
  }

  console.error('\n✗  Could not apply CORS. See output above.');
})().catch(console.error);
