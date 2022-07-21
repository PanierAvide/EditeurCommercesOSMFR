// Load original files
const info = require('./info.json');
const csvparse = require('csv-parse/sync');
const fs = require('fs');
const listing = csvparse.parse(fs.readFileSync('./listing.csv'), { columns: true });


// Create select based on listing of shop types
const typeSelect = {
	"type": "select", "name": "Type de commerce", "tag": "_select1", "values": []
};

typeSelect.values = listing.map(l => ({
	"l": l["nom en français dans ID"],
	"tags": Object.assign({"shop": "", "craft": "", "amenity": "", "office": ""}, { [l.key]: l.value })
}))
.sort((a,b) => (a.l.localeCompare(b.l)));

typeSelect.values.push({ "l": "Autre type de commerce", "tags": { "shop": "yes" } });


// Inject new values into info.json
info.editors.pdm.fields = info.editors.pdm.fields.map(f => f.tag === "_select1" ? typeSelect : f);
fs.writeFileSync('./info.json', JSON.stringify(info, null, 2), 'utf8');
console.log("Done");
