const fs = require('fs');
const path = require('path');

const SUPABASE_URL      = process.env.SUPABASE_URL      || '';
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY || '';

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  console.error('ERROR: SUPABASE_URL 또는 SUPABASE_ANON_KEY 환경변수가 설정되지 않았습니다.');
  process.exit(1);
}

const dist = path.join(__dirname, 'dist');
if (!fs.existsSync(dist)) fs.mkdirSync(dist);

function processFile(src, dest) {
  let content = fs.readFileSync(src, 'utf8');
  content = content.replaceAll('__SUPABASE_URL__',      SUPABASE_URL);
  content = content.replaceAll('__SUPABASE_ANON_KEY__', SUPABASE_ANON_KEY);
  fs.writeFileSync(dest, content, 'utf8');
  console.log(`Built: ${dest}`);
}

processFile('index.html',  path.join(dist, 'index.html'));
processFile('upload.html', path.join(dist, 'upload.html'));

console.log('빌드 완료!');
