
// read config
var configFile = cat('/mapic/config/mongo.json');

// parse config
var config = JSON.parse(configFile);
var password = config.password;
var user = config.user;
var database = config.database || 'mapic';

console.log('####################');
console.log('####################');
console.log('####################');
console.log('# mongo init')
console.log('# password', password);
console.log('# user: ', user);
console.log('# db', database);

// prime db for auth
var admin = connect('localhost:27017/admin');
admin.system.users.remove({})

// add user
var db = connect('localhost:27017/' + database);
db.createUser({user : user, pwd: password, roles : [{role : 'root', db: 'admin'}, {role : 'dbOwner', db: database}]})
